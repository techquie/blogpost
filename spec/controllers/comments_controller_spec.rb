require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:super_admin_user) { create(:user, role: 'super_admin') }
  let!(:visitor_user) { create(:user, role: 'visitor') }
  let!(:comment1) { create(:comment, comment_by: admin_user) }
  let!(:comment2) { create(:comment, comment_by: visitor_user, approved_by_admin: true) }

  describe 'GET #pending_approvals' do
    context 'when user is a admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        get :pending_approvals
      end

      it 'assigns @comments with admin pending approvals' do
        expect(assigns(:comments).first).to eq(comment1)
      end

      it 'renders the pending_approvals template' do
        expect(response).to render_template(:pending_approvals)
      end
    end

    context 'when user is an super admin' do
      before do
        allow(controller).to receive(:current_user).and_return(super_admin_user)
        get :pending_approvals
      end

      it 'assigns @comments with admin pending approvals' do
        expect(assigns(:comments).first).to eq(comment2)
      end

      it 'renders the pending_approvals template' do
        expect(response).to render_template(:pending_approvals)
      end
    end

    context 'when user is visitor' do
      before do
        allow(controller).to receive(:current_user).and_return(visitor_user)
        get :pending_approvals
      end

      it 'should redirect visitor to root path' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end

      it 'should not render pending_approvals template' do
        expect(response).not_to render_template(:pending_approvals)
      end
    end
  end

  describe 'POST #approve_comment' do
    let!(:comment3) { create(:comment, comment_by: visitor_user, approved_by_admin: false, approved_by_sadmin: false) }

    context 'when current_user is a super_admin' do
      before do
        allow(controller).to receive(:current_user).and_return(super_admin_user)
      end

      context 'when the comment update is successful' do
        before do
          post :approve_comment, params: { comment_id: comment3.id }
        end

        it 'approves the comment by a super_admin' do
          expect(comment3.approved_by_sadmin).to be_falsy
          expect(comment3.reload.approved_by_sadmin).to be_truthy
        end

        it 'returns success in the JSON response' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be true
          expect(json_response['message']).to eq('Comment approved successfully.')
        end
      end

      context 'when the comment_id is invalid' do
        before do
          post :approve_comment, params: { comment_id: 0 }
        end

        it 'returns failure in the JSON response' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be false
          expect(json_response['message']).to eq('Comment not found.')
        end

        it 'returns a 404 status' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when current_user is an admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      context 'when the comment update is successful' do
        before do
          post :approve_comment, params: { comment_id: comment3.id }
        end

        it 'approves the comment by an admin' do
          expect(comment3.approved_by_admin).to be_falsy
          expect(comment3.reload.approved_by_admin).to be_truthy
        end

        it 'returns success in the JSON response' do
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be true
          expect(json_response['message']).to eq('Comment approved successfully.')
        end
      end
    end

    context 'when user is visitor' do
      before do
        allow(controller).to receive(:current_user).and_return(visitor_user)
        post :approve_comment, xhr: true, params: { comment_id: comment3.id }
      end

      it 'should redirect visitor to root path' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('You are not authorized to perform this action.')
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #submit_comment' do
    let!(:story) { create(:story) }
    let(:params) { { comment: 'Nice story.', story_id: story.id } }

    shared_examples 'submit comments with different user roles' do |role|
      before(:each) do
        user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
        allow(controller).to receive(:current_user).and_return(user)
      end

      context "when the all passed parameter is valid for user #{role}" do
        it 'should create comment under the story' do
          post :submit_comment, xhr: true, params: params

          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be true
          expect(json_response['message']).to eq('Comment added successfully, wait for comment approval by admin.')
          expect(response).to have_http_status(:ok)
        end

        it 'should create comment under the story' do
          expect(Comment.count).to eq(2)
          post :submit_comment, xhr: true, params: params

          json_response = JSON.parse(response.body)
          expect(Comment.count).to eq(3)
        end
      end

      context "when the all passed parameter is invalid for user #{role}" do
        it 'should create comment under the story' do
          post :submit_comment, xhr: true, params: params.merge!(comment: '')

          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be false
          expect(json_response['message']).to eq('Failed to add comment.')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
    %w[admin super_admin visitor].each { |role| include_examples 'submit comments with different user roles', role }
  end
end

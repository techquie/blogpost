require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:super_admin_user) { create(:user, role: 'super_admin') }
  let!(:visitor_user) { create(:user, role: 'visitor') }

  describe 'GET #index' do
    context 'list all users' do
      shared_examples 'list users with different roles' do |role|
        it "list all users for #{role}" do
          user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
          allow(controller).to receive(:current_user).and_return(user)
          get :index
          validate_output(role)
        end
      end
      %w[admin super_admin visitor].each { |role| include_examples 'list users with different roles', role }
    end
  end

  describe 'POST #block_unblock_user' do
    let!(:user) { create(:user) }

    context 'verify block/unlock' do
      shared_examples 'verify block_unblock with different roles' do |role|
        it "block active users by #{role}" do
          current_user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
          allow(controller).to receive(:current_user).and_return(current_user)
          post :block_unblock_user, xhr: true, params: { user_id: user.id }
          validate_expection_block_unblock(role, "#{user.name} is blocked successfully.")
        end

        it "unblock blocked users by #{role}" do
          current_user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
          allow(controller).to receive(:current_user).and_return(current_user)
          user.update(active: false)
          post :block_unblock_user, xhr: true, params: { user_id: user.id }
          validate_expection_block_unblock(role, "#{user.name} is unblocked successfully.")
        end
      end
      %w[visitor admin super_admin].each { |role| include_examples 'verify block_unblock with different roles', role }
    end

    context 'should not allowed to block/unlock ownself' do
      it 'should restrict user to perform block' do
        allow(controller).to receive(:current_user).and_return(user)
        post :block_unblock_user, xhr: true, params: { user_id: user.id }
        expect(JSON.parse(response.body)['message']).to eq("can't block/unblock ownself.")
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  private

  def validate_expection_block_unblock(role, message)
    if role == 'visitor'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('You are not authorized to perform this action.')
      expect(response).to have_http_status(:forbidden)
    else
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['message']).to eq(message)
    end
  end

  def validate_output(role)
    if role == 'visitor'
      expect(response.status).to eq(302)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    else
      expect(assigns(:users).count).to eq(3)
      expect(response).to render_template(:index)
    end
  end
end

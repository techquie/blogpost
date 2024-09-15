require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let!(:admin_user) { create(:user, role: 'admin') }
  let!(:super_admin_user) { create(:user, role: 'super_admin') }
  let!(:visitor_user) { create(:user, role: 'visitor') }
  let!(:story1) { create(:story) }
  let!(:story2) { create(:story) }
  let!(:comment1) { create(:comment, story: story1, comment_by: visitor_user, approved_by_admin: false, approved_by_sadmin: false) }
  let!(:comment2) { create(:comment, story: story1, comment_by: visitor_user, approved_by_admin: true, approved_by_sadmin: false) }
  let!(:comment3) { create(:comment, story: story1, comment_by: visitor_user, approved_by_admin: true, approved_by_sadmin: true) }

  describe 'GET #index' do
    context 'when stories requested' do
      shared_examples 'list stories with different roles' do |role|
        it "should return list for #{role}" do
          user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
          allow(controller).to receive(:current_user).and_return(user)
          get :index
          expect(assigns(:stories).count).to eq(2)
        end
      end
      %w[admin super_admin visitor].each { |role| include_examples 'list stories with different roles', role }
    end
  end

  describe 'GET #show' do
    context 'when full story viewed' do
      shared_examples 'list stories with different roles' do |role|
        it "return only final approved comments for the story: user:: #{role}" do
          user = role == 'admin' ? admin_user : role == 'super_admin' ? super_admin_user : visitor_user
          allow(controller).to receive(:current_user).and_return(user)
          get :show, params: { id: story1.id }
          expect(assigns(:comments).first).to eq(comment3)
        end
      end
      %w[admin super_admin visitor].each { |role| include_examples 'list stories with different roles', role }
    end
  end
end

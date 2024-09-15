require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
  end

  describe 'verify association type' do
    context 'with users' do
      it 'return has_many' do
        expect(User.reflect_on_association(:comments_by_user).macro).to eq(:has_many)
      end
    end

    context 'with story' do
      it 'return has_many' do
        expect(User.reflect_on_association(:story).macro).to eq(:has_one)
      end
    end
  end
end

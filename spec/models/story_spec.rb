require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'verify association type' do
    context 'with comments' do
      it 'return has_many' do
        expect(Story.reflect_on_association(:comments).macro).to eq(:has_many)
      end
    end
  end
end

  require 'rails_helper'

  RSpec.describe Expert, type: :model do
   it "should has_many courses" do
        t =Expert.reflect_on_association(:courses)
        expect(t.macro).to eq(:has_many)
      end
    end
    context 'Active Storage' do
    it 'has one attached profile_picture' do
      expect(Expert.new).to have_one_attached(:profile_picture)
    end
  end


require 'rails_helper'

RSpec.describe Purchase, type: :model do

  context "association test" do
    it 'should belongs_to association' do 
      t = Purchase.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'should belongs_to association' do 
      t = Purchase.reflect_on_association(:course)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end

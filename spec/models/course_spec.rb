  require 'rails_helper'

  RSpec.describe Course, type: :model do
    it "should belongs_to account" do
      t =Course.reflect_on_association(:expert)
      expect(t.macro).to eq(:belongs_to)
    end
  end
  context 'validations' do
    it 'ensure presence of some attributes' do
      course =Course.create()
      expect(course.errors.messages[:title])==(["can't be blank"])
      expect(course.errors.messages[:category])==(["can't be blank"])
      expect(course.errors.messages[:price])==(["can't be blank"])
    end
  end
   

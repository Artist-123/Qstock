  require 'rails_helper'

  RSpec.describe User, type: :model do

    context "association test" do
      it 'should has_many association' do 
        byebug
        t = User.reflect_on_association(:purchases)
        expect(t.macro).to eq(:has_many)
      end
    end
    context 'validations' do
      it 'ensure presence of email' do
        user =User.create()
        expect(user.errors.messages[:email])==(["can't be blank"])
        expect(user.errors.messages[:password])==(["can't be blank"])
      end
      end
       context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_least(4).is_at_most(254) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email).with_message('invalid') }
    it { should allow_value('P@ssw0rd').for(:password) }
    it { should_not allow_value('password').for(:password).with_message('must contain at least one digit and one special character') }
  end
    context 'callbacks' do
      it 'calls generate_and_assign_otp before create' do
        expect(subject).to receive(:generate_and_assign_otp)
        subject.run_callbacks(:create) 
    end
     end

     context 'has_secure_password' do
    it 'adds password attribute' do
      expect(User.new).to respond_to(:password)
    end

    it 'validates presence of password on create' do
      user = User.new(password: nil)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'encrypts the password' do
      password = 'password123'
      user = User.create(password: password)
      expect(user.password_digest).to_not eq(password)
      expect(user.authenticate(password)).to be_truthy
    end
  end
   context 'enums' do
    it { should define_enum_for(:role).with_values(user: 0, expert: 1, admin: 2) }
  end
end

 

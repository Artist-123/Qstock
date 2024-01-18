class Addcolumntousers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_password_otp, :integer
    add_column :users, :reset_password_otp_sent_at, :datetime
    add_column :users, :otp_attempts, :integer, default: 0
    add_column :users, :last_otp_attempt, :datetime
  end
end

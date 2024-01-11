class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activated, :boolean
    add_column :users, :otp, :integer
    add_column :users, :reset_token, :string
    add_column :users, :reset_token_sent_at, :datetime
    add_column :users, :valid_until, :datetime
    remove_column :users, :username, :string
  end
end

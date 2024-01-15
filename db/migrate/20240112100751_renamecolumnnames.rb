class Renamecolumnnames < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :reset_token, :reset_password_token
    rename_column :users, :reset_token_sent_at, :reset_password_token_sent_at
  end
end

class CreateExperts < ActiveRecord::Migration[6.1]
  def change
    create_table :experts do |t|
      t.string :name
      t.string :expertise
      t.string :description

      t.timestamps
    end
  end
end

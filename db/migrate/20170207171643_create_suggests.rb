class CreateSuggests < ActiveRecord::Migration[5.0]
  def change
    create_table :suggests do |t|
      t.string :title
      t.string :content
      t.string :status
      t.string :integer
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end

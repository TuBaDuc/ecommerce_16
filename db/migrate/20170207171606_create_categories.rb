class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :level
      t.string :parent_path
      t.boolean :is_leaf

      t.timestamps
    end
  end
end

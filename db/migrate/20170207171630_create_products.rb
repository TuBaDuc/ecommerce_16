class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.string :photo
      t.string :description
      t.float :price
      t.integer :in_stock
      t.float :avg_rating
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end

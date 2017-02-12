class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :code
      t.integer :status
      t.float :total_bill
      t.string :ship_address
      t.integer :contact_phone
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

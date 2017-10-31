class AddPaymentTypeToOrders < ActiveRecord::Migration[5.0]
  def up
    add_reference :orders, :payment_type, foreign_key: true

    remove_column :orders, :pay_type
  end
  def down
    add_column :orders, :pay_type
  end
end

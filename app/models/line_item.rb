class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    price * quantity
  end

  def decrement_quantity(item)
    if item.quantity <= 1
      item.destroy
    else
      item.quantity -= 1
      item.save!
    end
    item
  end
end

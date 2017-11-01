require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
    # @order.line_items << line_items(:two)
  end
  test "received" do
    mail = OrderMailer.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ["jay@example.org"], mail.to
    assert_equal ["depot@example.org"], mail.from
    assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(@order)
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ["jay@example.org"], mail.to
    assert_equal ["depot@example.org"], mail.from
    assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end
end

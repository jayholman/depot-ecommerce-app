require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :payment_types
  include ActiveJob::TestHelper

  test "buying a product" do
    start_order_count = Order.count
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_select 'h1', "Your Pragmatic Catalog"

    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'

    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name: "Jay Holman",
          address: "123 The Street",
          email: "jay@example.org",
          payment_type_id: payment_types(:credit_card).id
        }
      }
      follow_redirect!

      assert_response :success
      assert_select 'h1', "Your Pragmatic Catalog"
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      assert_equal start_order_count + 1, Order.count
      order = Order.last

      assert_equal "Jay Holman", order.name
      assert_equal "123 The Street", order.address
      assert_equal "jay@example.org", order.email
      assert_equal "Credit Card", order.payment_type.name

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["jay@example.org"], mail.to
      assert_equal 'Sam Ruby <depot@example.org>', mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
  end
end

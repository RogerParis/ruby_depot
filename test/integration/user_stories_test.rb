require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # A user goes to the store index page
    get "/"
    assert_response :success
    assert_template "index"

    # They select a product, adding it to their cart.
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # They then check out...
    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
          order: {  name: "Roger Paris",
                    address: "Richardallee 10",
                    email: "roger.parisvicent@gmail.com",
                    pay_type: "Check"
          }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Roger Paris", order.name
    assert_equal "Richardallee 10", order.address
    assert_equal "roger.parisvicent@gmail.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["roger.parisvicent@gmail.com"], mail.to
    assert_equal 'Roger Paris <roger.paris@njiuko.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end

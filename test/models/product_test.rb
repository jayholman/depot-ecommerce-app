require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(
      title: "The Hitchhikers Guide to the Galaxy",
      description: "What is life, the universe, and everything?",
      image_url: "mice.gif"
    )

    product.price = -42
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: "So Long and Thanks for all the Fish",
      description: "Dolphins",
      price: 1,
      image_url: image_url
    )
  end

  test "image url" do
    ok = %w{ zaphod.gif zaphod.jpg zaphod.png ZAPHOD.JPG ZAPHOD.jpg
            http://a.b.c/x/y/z/zaphod.gif }
    bad = %w{ zaphod.doc zaphod.gif/more zaphod.gif.more }

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} shoulnd't be valid"
    end
  end
end

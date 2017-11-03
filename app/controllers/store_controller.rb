class StoreController < ApplicationController
  skip_before_action :authorize
  include CurrentCart
  before_action :set_cart

  def index
    @products = Product.order(:title)
    @counter = increment_counter
  end

  private
    def increment_counter
      session[:counter] ||=0
      session[:counter] += 1
      if session[:counter] > 5
        return session[:counter]
      end
    end
end

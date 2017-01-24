class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
  end

  private 
    def set_cart_counter
      session[:counter] ||= 0
      session[:counter] += 1
    end
end

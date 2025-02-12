class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui
  before_action :initialize_cart_service
  
  def add_item
    cart = @cart_service.add_product(params[:product_id], params[:quantity].to_i)
    render json: { id: session.id, products: cart.values, total_price: calculate_total_price(cart) }, status: :ok
  end

  def show
    cart = @cart_service.fetch_cart
    render json: { id: session.id, products: cart.values, total_price: calculate_total_price(cart) }, status: :ok
  end

  def update_item
    cart = @cart_service.update_product(params[:product_id], params[:quantity].to_i)
    render json: { id: session.id, products: cart.values, total_price: calculate_total_price(cart) }, status: :ok
  end

  def remove_item
    cart = @cart_service.remove_product(params[:product_id])
    render json: { id: session.id, products: cart.values, total_price: calculate_total_price(cart) }, status: :ok
  end

  private

  def initialize_cart_service
    @cart_service = CartService.new(session.id)
  end

  def calculate_total_price(cart)
    cart.values.sum { |item| item['quantity'].to_i * item['unit_price'].to_f }
  end
end

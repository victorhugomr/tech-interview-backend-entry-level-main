class CartService
    def initialize(session_id)
      @session_id = session_id
      @redis = Redis.new
    end
  
    def add_product(product_id, quantity)
      product = Product.find_by(id: product_id)
      raise ActiveRecord::RecordNotFound, "Product not found" unless product
      
      cart = fetch_cart
      if cart[product_id.to_s]
        cart[product_id.to_s]['quantity'] += quantity
      else
        cart[product_id.to_s] = { 'id' => product.id, 'name' => product.name, 'quantity' => quantity, 'unit_price' => product.price }
      end
      save_cart(cart)
      cart
    end
  
    def update_product(product_id, quantity)
      cart = fetch_cart
      if cart[product_id.to_s]
        cart[product_id.to_s]['quantity'] = quantity
        save_cart(cart)
      end
      cart
    end
  
    def remove_product(product_id)
      cart = fetch_cart
      cart.delete(product_id.to_s)
      save_cart(cart)
      cart
    end
  
    def fetch_cart
      cart = @redis.get("cart:#{@session_id}")
      cart ? JSON.parse(cart) : {}
    end
  
    private
  
    def save_cart(cart)
      @redis.set("cart:#{@session_id}", cart.to_json)
    end
  end
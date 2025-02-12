class CartCleanupJob
    include Sidekiq::Worker
    sidekiq_options queue: :default
  
    def perform
        Cart.where("updated_at < ?", 3.hours.ago).each do |cart|
            unless cart.abandoned_at
              cart.update(abandoned_at: Time.current)
            end

          Cart.where("abandoned_at < ?", 7.hours.ago).destroy_all
        end
    end
end

class CartCleanupJob
    include Sidekiq::Job
    sidekiq_options queue: :default
  
    def perform
        ## cart_clear
    end
end

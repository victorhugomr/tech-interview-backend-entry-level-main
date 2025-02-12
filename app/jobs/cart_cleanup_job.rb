class CartCleanupJob
    include Sidekiq::Job
    sidekiq_options queue: :default
  
    def perform
    end
end

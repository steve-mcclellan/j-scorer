ActiveJob::Status.store = ActiveSupport::Cache::MemoryStore.new
ActiveJob::Status.options = { expires_in: 24.hours.to_i }

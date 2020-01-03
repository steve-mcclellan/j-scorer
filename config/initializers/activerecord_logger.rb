# Remove debug logs from ActiveRecord (which fill the logs with
# unhelpful SQL-query text)
ActiveRecord::Base.logger.level = Logger::INFO

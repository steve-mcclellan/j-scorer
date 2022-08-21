module StatsHelper
  include Pagy::Frontend

  def pagy_url_for(_pagy, page)
    "#{stats_url}#games_#{page}"
  end
end

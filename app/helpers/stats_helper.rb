module StatsHelper
  include Pagy::Frontend

  def pagy_url_for(page, pagy)
    "#{stats_url}#games_#{page}"
  end
end

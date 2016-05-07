module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'J! Scorer'
    page_title.blank? ? base_title : base_title + ' - ' + page_title
  end
end

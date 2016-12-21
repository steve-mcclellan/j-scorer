module UsersHelper
  # Displays a success rate line a la "3/5 (60.0%)" or "0/0"
  def display_rate(arr)
    n, d, avg = arr

    return "#{n}/#{d}" if avg.nil?
    "#{n}/#{d} (#{number_to_percentage(avg * 100, precision: 1)})"
  end
end

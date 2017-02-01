module UsersHelper
  # Displays a success rate line, a la "3/5 (60.0%)" or "0/0".
  def display_rate(arr)
    n, d, avg = arr

    return "#{n}/#{d}" if avg.nil?
    "#{n}/#{d} (#{number_to_percentage(avg * 100, precision: 1)})"
  end

  # Displays just a percentage, a la "60%" or "--%".
  def display_percentage(data, reverse = false)
    avg = data.is_a?(Array) ? data[2] : data
    return '--%' if avg.nil?

    avg = 1 - avg if reverse
    number_to_percentage(avg * 100, precision: 0)
  end

  def sample_size(arr)
    arr[1]
  end
end

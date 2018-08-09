# Utils for date manipulation
module DateUtils
  # Time diff on hours
  def time_diff(time_a, time_b)
    (Time.parse(time_b) - Time.parse(time_a)) / 3600.0
  end

  # Compares if range is onto other range
  def in_time_range?(range_a, range_b, separator = '-')
    range_a_array = range_a.split(separator)
    range_b_array = range_b.split(separator)
    range_b_array[0] >= range_a_array[0] && range_b_array[1] <= range_a_array[1]
  end
end

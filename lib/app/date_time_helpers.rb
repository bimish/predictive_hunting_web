module DateTimeHelpers

  def self.set_date_part(date_time_value, new_date)
    date_time_value.change(:year => new_date.year, :month => new_date.month, :day => new_date.day)
  end
  def self.set_time_part(date_time_value, new_time)
    date_time_value.change(:hour => new_time.hour, :min => new_time.min, :sec => new_time.sec)
  end

end

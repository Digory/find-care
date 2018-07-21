require('date')

class CheckDate

  def self.is_in_past?(date, time)
    checked_date = DateTime.parse(date + " " + time)
    return DateTime.now > checked_date
  end

end

p CheckDate.is_in_past?("2002-01-01", "02:12")

require('date')
require('chronic')

class CheckDate

  def self.is_in_past?(date, time)
    checked_date = DateTime.parse(date + " " + time)
    return DateTime.now > checked_date
  end

  # Takes in a day of the week and time (e.g. "Tuesday" and "10am") and returns a Time object in the form that SQL likes (e.g. 2018-07-31 10:00:00).

  def self.find_next_day_of_the_week(day_of_the_week, time)
    return Chronic.parse("next #{day_of_the_week} at #{time}")
  end

end

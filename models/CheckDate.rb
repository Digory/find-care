require('date')
require('chronic')

class CheckDate

  def self.is_in_past?(date, time)
    checked_date = DateTime.parse(date + " " + time)
    return DateTime.now > checked_date
  end

  def self.find_next_day_of_the_week(day_of_the_week, time)
    return Chronic.parse("next #{day_of_the_week} at #{time}")
  end
  # 
  # def self.get_words_from_date_and_time(date, time)
  #   return DateTime.parse(date + " " + time).strftime("%A at %l:%M%P")
  # end

end

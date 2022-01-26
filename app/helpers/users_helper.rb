module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  require 'rounding'
  def min_round(min)
    format("%.0f",((min / 15).round) * 15)
  end
end

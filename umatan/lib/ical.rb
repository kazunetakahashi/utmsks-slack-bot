class Ical
  require 'icalendar'
  require 'open-uri'
  require 'active_support/all'

  def Ical.get_info(n)
    url = "https://topcoder.g.hatena.ne.jp/calendar?date=2016-06-23&mode=ical"
    nday = Date.today + n.day
    ret = []
    open(url) {|input|
      cal = Icalendar.parse(input.read, true)
      cal.events.each{|event|
        if event.dtstart == nday
          if event.summary.is_a?(Icalendar::Values::Array)
            ret << nday.strftime("%m/%d(%a)") + event.summary.join
          elsif event.summary.is_a?(Icalendar::Values::Text)
            ret << nday.strftime("%m/%d(%a)") + event.summary
          end              
        end
      }
    }
    return ret
  end
  
end

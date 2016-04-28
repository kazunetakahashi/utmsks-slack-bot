# coding: utf-8

require 'active_support/all'

def time_match(t, d)
  now = Time.now()
  start_time = Time.new(now.year, now.month, now.day) + d.days
  end_time = Time.new(now.year, now.month, now.day) + (d+1).days
  return start_time <= t && t < end_time
end

# TA小話リマインダ

schedule '30 12 * * *' do
  @kobanashi.each{|sch|
    if time_match(sch[1], 0)
      say "<@#{sch[0]}> 今日は TA 小話の日だな。少し早く実習室へ行って、スタンバイだ。発表、期待しているぜ。", channel: 'ta_kobanashi'
    end
  }
end

schedule '0 10 * * *' do
  @kobanashi.each{|sch|
    if time_match(sch[1], 3)
      say "<@#{sch[0]}> 今週は TA 小話があるぞ。準備は進んでいるかな。", channel: 'ta_kobanashi'
    end
  }
end

schedule '0 17 * * *' do
  @kobanashi.each{|sch|
    if time_match(sch[1], 7)
      say "<@#{sch[0]}> 来週の TA 小話、任せたぜ。", channel: 'ta_kobanashi'
    end
  }
end

# 実習リマインダ

schedule '0 10 * * *' do
  @lectures.each{|sch|
    if time_match(sch[1], 0)
      str = "計算数学の実習"
      if !(sch[0].nil? || sch[0] == '')
        str += "「#{sch[0]}」"
      end
      str += "が、今日の#{sch[1].strftime('%H時%M分')}から始まるぞ。頑張ろうぜ。"
      say str, channel: 'general'
    end
  }
end

# イベントリマインダ

schedule '0 10 * * *' do
  @events.each{|sch|
    if time_match(sch[1], 0)
      say "今日の#{sch[1].strftime('%H時%M分')}から、#{sch[0]}があるな。張り切っていこう。", channel: 'general'
    end
  }
end


# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by kurumi'
end
#
#
# # called when match message
# hear 'foo' do
#   puts 'foo'
# end
#
#
# # use regexp in string literal
# hear 'bar (.*)' do |event|
#   puts event.matches[1] #=> Event#matches return MatchData object
# end
#
#
# # event object is slack event JSON (convert to Hashie::Mash)
# hear '^bar (.*)' do |event|
#   puts event.channel #=> channel id
#   say 'slappy!', channel: event.channel #=> to received message channel
#   say 'slappy!', channel: '#general'
#   say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:'
# end
#
#
# # use regexp literal
# hear /^foobar/ do
#   say 'slappppy!'
# end

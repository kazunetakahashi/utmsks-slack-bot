# coding: utf-8

hear MYNAME do |event|
  res = Ical.get_info(1)
  if res.empty?
    say "こんばんは。明日はコンテストが開かれないようでございます。どうぞごゆっくり。", channel: event.channel
  else
    say "こんばんは。明日開かれるコンテストは、", channel: event.channel
    res.each{|str|
      say str, channel: event.channel
    }
    say "でございます。がんばってくださいまし。", channel: event.channel
  end
end

schedule '0 20 * * *' do
  res = Ical.get_info(1)
  if res.empty?
    say "こんばんは。明日はコンテストが開かれないようでございます。どうぞごゆっくり。", channel: '#bot'
  else
    say "こんばんは。明日開かれるコンテストは、", channel: '#bot'
    res.each{|str|
      say str, channel: '#bot'
    }
    say "でございます。がんばってくださいまし。", channel: '#bot'
  end
end

# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by umatan'
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

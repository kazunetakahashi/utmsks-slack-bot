# coding: utf-8
# Slappy Examples
#
# # called when start up
botnum = 1

hello do
  puts 'successfly connected by futaba'
end

schedule '*/5 * * * *' do
  now = Time.now
  if now.min % 15 == botnum * 5
    str = "今、" + now.strftime("%H時%M分") + "だよ。"
    say str, channel: '#botalive'      
  end
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

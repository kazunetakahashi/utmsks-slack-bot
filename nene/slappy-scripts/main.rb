# coding: utf-8
# Slappy Examples
#
# # called when start up
hello do
  puts 'successfly connected by nene'
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
hear 'クラりん' do |event|
  puts event.channel #=> channel id
  say 'クラりーん。迎えに来てくれたんだ。ありがとうー', channel: event.channel #=> to received message channel
#   say 'slappy!', channel: '#general'
#   say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:'
end
#
#
# # use regexp literal
# hear /^foobar/ do
#   say 'slappppy!'
# end

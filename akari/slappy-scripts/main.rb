# coding: utf-8
# Slappy Examples
#
# # called when start up
hello do
  puts 'successfly connected by akari'
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
hear '.*' do |event|
  puts event.channel #=> channel id
  if event.text.include?('わぁい')
    next
  end
  event.reply 'わぁい' + event.text + ' あかり' + event.text + '大好き'
  #say 'わぁい' + event.text + ' あかり' + event.text + '大好き', channel: event.channel #=> to received message channel
#   say 'slappy!', channel: '#general'
#   say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:'
end
#
#
# # use regexp literal
# hear /^foobar/ do
#   say 'slappppy!'
# end

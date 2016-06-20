# coding: utf-8
# Slappy Examples
#
# # called when start up

name = ["yoko", "futaba", "teru"]
before = ["現在の時刻は", "今、", "今の時刻は"]
after = ["ですわ。", "だよ。", "かな。"]

hello do
  puts "successfly connected by #{name[BOTNUM]}"
end

schedule '* * * * *' do
  now = Time.now
  if now.min % 3 == BOTNUM
    str = before[BOTNUM] + now.strftime("%H時%M分") + after[BOTNUM]
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

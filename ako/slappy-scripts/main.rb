# coding: utf-8
# https://github.com/sferik/twitter/blob/master/README.md を参考に

# Slappy Examples
#
# called when start up
require 'twitter'

@last_time
@channel = '#twitter_hashtag'

hello do
  puts 'successfly connected by ako'
  @last_time = get_last_time()
end

schedule '* * * * *' do
  puts "last time #{@last_time}"
  tw = every_minutes(@last_time)
  puts "tweets #{tw.size}"
  if tw.empty?
    next
  end
  say "ツイート見つけました〜。奥さんって夫の浮気は一目で分かるんですよ？", channel: @channel
  tw.each{|t|
    say saying(t), channel: @channel
  }
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

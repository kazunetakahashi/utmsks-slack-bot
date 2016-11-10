# coding: utf-8

require 'active_support/all'
require 'open-uri'

def search(str)
  res = nil
  if str.size() == 5
    sleep(1.1)
    begin
      open("http://www.siam.org/#{str}/") {|f|
        return str
      }
    rescue
      puts "#{str} not found"
      return nil
    end
  elsif str.size() <= 2
    for x in 'a'..'z'
      res = search(str + x)
      if !res.nil?
        return res
      end
    end
  elsif str.size() == 3
    res = search(str + 'r')
    if !res.nil?
      return res
    end
  else
    for x in ['o', 'p']
      res = search(str + x)
      if !res.nil?
        return res
      end
    end
  end
  if str.size() == 2
    say "#{str} not found", channel: '#bottest'
  end
  return nil
end

# Slappy Examples
#
# called when start up
=begin
hello do
  puts 'successfly connected by ayame'
  ans = search("")
  if ans.nil?
    say 'すまんみんな。全部探したけど、正しい URL を見つけられなかった！ 問題解けなくてゴメンな。', channel: '#random'
  else
    say "おーいみんなー。見つかったぞ！ 答えはきっと http://www.siam.org/#{ans}/ だ。確かめてみてくれよ！", channel: '#random'
  end
end
=end
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

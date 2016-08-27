# coding: utf-8

@crawl = nil
@channel = "#bot"

schedule '*/5 * * * *' do
  list = @crawl.koshin_list
  list.each{|l|
    say l.str, channel: @channel
  }
end

# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by mizuki'
  @crawl = Crawl.new($crawl_list)
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

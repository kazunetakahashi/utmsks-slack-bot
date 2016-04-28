# coding: utf-8

@now_raining

hear MYNAME do |event|
  p event.text
  str = "お呼びですか、兄さん。"
  cityname = event.text[/「(.*)」/, 1]
  if cityname.nil? || cityname == ''
    str += "私に天気を尋ねる際は、「」の中に都市名を入れて尋ねてください。"
  else
    resid = search_city_id(cityname)
    if resid.nil?
      str += "「#{cityname}」という都市の天気は見当たりませんでした。"
      str += "例えば、県名を入れると、県庁所在地の天気を調べます。"
    else
      json = make_weather_json(resid)
      str += otenki(json, 0)
      str += otenki(json, 1)
      str += "もう、兄さんは忘れっぽいんだから…"
    end
  end
  say str, channel: event.channel
end

schedule '0 7 * * *' do
  json = make_weather_json("130010")
  str = "おはようございます、兄さん。" + otenki(json, 0) + "今日もいい日でありますように。"
  say str, channel: '#random'
end

schedule '0 19 * * *' do
  json = make_weather_json("130010")
  str = "こんばんは、兄さん。" + otenki(json, 1) + "今日もお勤め、お疲れ様でした。"
  say str, channel: '#bottest'
end

schedule '*/5 * * * *' do
  t = rain_beginning()
  raining = !(t.nil?)
  if raining && !@now_raining
    say "駒場では、#{t.strftime("%H時%M分")}から雨が降り出すようです。お気をつけて。", channel: '#random'
  elsif !raining && @now_raining
    say "駒場では、雨が止んだようですね。しばらく降らなそうです。", channel: '#bottest'
  end
  @now_raining = !(t.nil?)
end

# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by airi'
  @now_raining = !(rain_beginning().nil?)
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

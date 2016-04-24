# coding: utf-8
require 'faraday'
require 'json'

conn = Faraday::Connection.new(:url => 'http://weather.livedoor.com') do |builder|
  builder.use Faraday::Request::UrlEncoded
  builder.use Faraday::Response::Logger
  builder.use Faraday::Adapter::NetHttp
end
  
def otenki(json, num)
  city = json['location']['city']
  day = json['forecasts'][num]['dateLabel']
  weather = json['forecasts'][num]['telop']
  max = json['forecasts'][num]['temperature']['max']
  min = json['forecasts'][num]['temperature']['min']
  str = ""
  str += city + "の" + day + "の天気は" + weather + "です。"
  if weather.include?("雨")
    str += "傘をお持ちになってください。"
  end
  if !max.nil?
    str += "最高気温は" + max['celsius'] + "度"
  end
  if !max.nil? && !min.nil?
    str += "、"
  end
  if !min.nil?
    str += "最低気温は" + min['celsius'] + "度"
  end
  if !max.nil? || !min.nil?
    str += "です。"
  end
  return str
end

hear MYNAME do |event|
  p event.text
  str = "お呼びですか、兄さん。"
  cityname = event.text[/「(.*)」/, 1]
  if cityname.nil? || cityname == ''
    str += "私に天気を尋ねる際は、「」の中に都市名を入れて尋ねてください。"
  else
    resid = search_city_id(cityname)
    if resid.nil?
      str += "「" + cityname + "」という都市の天気は見当たりませんでした。"
      str += "例えば、県名を入れると、県庁所在地の天気を調べます。"
    else
      response = conn.get do |request|
        request.url ('/forecast/webservice/json/v1?city=' + resid)
      end
      json = JSON.parser.new(response.body).parse
      str += otenki(json, 0)
      str += otenki(json, 1)
      str += "お役に立つと幸いです。"
    end
  end
  say str, channel: event.channel
end

hear 'アイリテスト' do |event|
  response = conn.get do |request|
    request.url '/forecast/webservice/json/v1?city=130010'
  end
  json = JSON.parser.new(response.body).parse
  str = "おはようございます、兄さん。" + otenki(json, 0) + "今日もいい日でありますように。"
  say str, channel: event.channel
end

schedule '0 7 * * *' do
  response = conn.get do |request|
    request.url '/forecast/webservice/json/v1?city=130010'
  end
  json = JSON.parser.new(response.body).parse
  str = "おはようございます、兄さん。" + otenki(json, 0) + "今日もいい日でありますように。"
  say str, channel: '#random'
end

schedule '0 19 * * *' do
  response = conn.get do |request|
    request.url '/forecast/webservice/json/v1?city=130010'
  end
  json = JSON.parser.new(response.body).parse
  str = "こんばんは、兄さん。" + otenki(json, 1) + "今日もお勤め、お疲れ様でした。"
  say str, channel: '#random'
end

# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by airi'
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

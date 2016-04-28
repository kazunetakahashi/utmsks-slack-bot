# coding: utf-8
# http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/

require 'open-uri'
require 'nokogiri'
require 'faraday'
require 'json'

def search_city_id(name)
  url = 'http://weather.livedoor.com/forecast/rss/primary_area.xml'
  doc = Nokogiri::XML(open(url))
  if name == ""
    return nil
  elsif name == "北海道"
    name = "札幌"
  end
  doc.xpath('//city').each{|tag|
    if tag['title'].include?(name)
      return tag['id']
    end
  }
  doc.xpath('//pref').each{|tag|
    if tag['title'].include?(name)
      return tag.xpath('city')[0]['id']
    end
  }
  return nil
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

def make_json_template(u, d)
  conn = Faraday::Connection.new(:url => u) do |builder|
    builder.use Faraday::Request::UrlEncoded
    builder.use Faraday::Response::Logger
    builder.use Faraday::Adapter::NetHttp
  end
  response = conn.get do |request|
    request.url(d)
  end
  return JSON.parser.new(response.body).parse  
end

def make_weather_json(resid)
  url = 'http://weather.livedoor.com'
  dir = '/forecast/webservice/json/v1?city=' + resid
  return make_json_template(url, dir)
end

def make_yahoo_json()
  url = 'http://weather.olp.yahooapis.jp'
  dir = "/v1/place?appid=#{YAHOOAPPID}&coordinates=139.686621,35.658589&output=json&interval=5"
  return make_json_template(url, dir)
end

def make_rain_array()
  json = make_yahoo_json()
  h = json['Feature'][0]["Property"]["WeatherList"]["Weather"]
  h.map{|weather|
    weather['Date'] = Time.strptime(weather['Date'], "%Y%m%d%H%M")
  }
  return h.sort_by{|weather|
    weather['Date']
  }
end

def rain_beginning()
  ary = make_rain_array()
  ary.each{|weather|
    if weather['Rainfall'] > 0
      return weather['Date']
    end
  }
  return nil
end

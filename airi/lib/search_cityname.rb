# coding: utf-8
# http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/

require 'open-uri'
require 'nokogiri'

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

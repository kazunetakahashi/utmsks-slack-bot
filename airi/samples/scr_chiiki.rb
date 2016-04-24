# coding: utf-8
# http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/

require 'open-uri'
require 'nokogiri'

url = 'http://weather.livedoor.com/forecast/rss/primary_area.xml'
doc = Nokogiri::XML(open(url))

p doc.xpath('//city').first['id']

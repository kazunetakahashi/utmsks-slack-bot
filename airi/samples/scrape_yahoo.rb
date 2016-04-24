# coding: utf-8
# http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/

require 'open-uri'
require 'nokogiri'

# スクレイピング先のURL
url = 'http://www.yahoo.co.jp/'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

doc = Nokogiri::HTML.parse(html, nil, charset)

p doc.to_s

# coding: utf-8

class TrainLine
  require 'open-uri'
  require 'nokogiri'

  attr_accessor :name, :id, :recent, :time, :isnormal

  @@my_file = File.expand_path('../lineids.txt', __FILE__)
  @@info_hash # 1日1回、電車動いてない時間に TrainLine::init() するつもり。
  @@watching

  def initialize(id, name)
    id = id.to_s
    @id = id
    @name = name
    refresh
  end

  def self.new_id(id)
    name = nil
    ans = self.new(id, name)
    ans.name
    return ans
  end

  def name
    if @name.nil?
      @@info_hash.each{|it|
        if it[:line_id] == @id
          return @name = it[:line_name]
        end
      }
      return @name = nil
    end
    return @name
  end

  def url
    return "http://transit.yahoo.co.jp/traininfo/detail/#{@id}/0/"
  end

  def recent
    TrainLine::slack_escape(@recent)
  end

  def info
    image = (isnormal ? ":large_blue_circle: " : ":red_circle: ")
    return image + "【#{@name}】#{recent}(#{@time.strftime("%H時%M分現在")})"
  end

  def refresh
    url = self.url
    doc = Nokogiri::HTML(open(url))
    text = doc.xpath('//meta[@property="og:description"]').first.get_attribute('content')
    regexp = /(.*)（([0-9]{1,2})月([0-9]{1,2})日 ([0-9]{1,2})時([0-9]{1,2})分時点の情報です。最新情報はYahoo!路線情報で）/
    @recent = text[regexp, 1]
    month = text[regexp, 2].to_i
    day = text[regexp, 3].to_i
    hour = text[regexp, 4].to_i
    min = text[regexp, 5].to_i
    now = Time.now
    year = now.year
    if now.month == 1 && now.day == 1 && month == 12 && day == 31
      year -= 1
    end
    @time = Time.new(year, month, day, hour, min)
    @isnormal = doc.xpath('//div[@id="mdServiceStatus"]//dl//dt').text.include?("平常運転")
  end

  class << self

    def watching
      @@watching
    end

    def init()
      url = 'http://transit.yahoo.co.jp/traininfo/area/4/'
      doc = Nokogiri::HTML(open(url))
      @@info_hash = []
      doc.xpath('//div[@class="elmTblLstLine"]//tr//td//a').each{|it|
        line = {line_name: it.text, line_id: it.get_attribute('href')[/http:\/\/transit.yahoo.co.jp\/traininfo\/detail\/(.*)\/0\//, 1]}
        @@info_hash << line
      }
    end
    
    def search_lines(str)
      ans = @@info_hash.select{|it|
        it[:line_name].include?(str)
      }
      return ans
    end

    def watching_ids() # arrayが必要になるたびに呼び出す
      ans = []
      File.open(@@my_file){|file|
        file.each_line{|line|
          ans << line.chomp
        }
      }
      return ans.sort()
    end

    def add_id(id)
      if watching_ids.include?(id)
        return false
      end
      
      File.open(@@my_file, 'a'){|file|
        file.puts(id)
      }
      return true
    end

    def delete_id(id)
      if !(watching_ids.include?(id))
        return false
      end
      x = watching_ids
      File.open(@@my_file, 'w'){|file|
        x.each{|line|
          if line == id
            next
          end
          file.puts(line)
        }
      }  
      return true
    end

    def ary_to_lines(ary)
      ans = @@info_hash.select{|it|
        ary.include?(it[:line_id]) 
      }
      return ans
    end

    def make_watching()
      @@watching = []
      ary_to_lines(watching_ids).each{|it|
        @@watching << TrainLine.new(it[:line_id], it[:line_name])
      }
    end

    def slack_escape(str)
      ans = str
      chars = ['>', '\\`', '_', '\\*', '~', ]
      chars_r = ['>', '`', '_', '*', '~', ]
      chars.size.times{|i|
        ch = chars[i]
        ch_r = chars_r[i]
        ans.gsub!(/#{ch}/, " #{ch_r} ")
      }
      ans.gsub!(/\s(?=\s)/, '')
      return ans
    end
    
  end

end





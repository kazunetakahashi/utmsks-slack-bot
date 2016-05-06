require 'open-uri'
require 'nokogiri'

def make_lines
  url = 'http://transit.yahoo.co.jp/traininfo/area/4/'
  doc = Nokogiri::HTML(open(url))
  ans = []
  doc.xpath('//div[@class="elmTblLstLine"]//tr//td//a').each{|it|
    line = {line_name: it.text, line_id: it.get_attribute('href')[/http:\/\/transit.yahoo.co.jp\/traininfo\/detail\/(.*)\/0\//, 1]}
    ans << line
  }
  return ans
end

def search_line(str)
  ans = make_lines.select{|it|
    it[:line_name].include?(str)
  }
  return ans
end

def line_id_to_url(id)
  return "http://transit.yahoo.co.jp/traininfo/detail/#{id}/0/"
end

def make_ids()
  ans = []
  File.open('lineids.txt'){|file|
    file.each_line{|line|
      ans << line.chomp
    }
  }
  return ans.sort()
end

def add_id(id)
  if make_ids.include?(id)
    return false
  end
  File.open('lineids.txt', 'a'){|file|
    file.puts(id)
  }
  return true
end

def delete_id(id)
  if !(make_ids.include?(id))
    return false
  end
  x = make_ids
  File.open('lineids.txt', 'w'){|file|
    x.each{|line|
      if line == id
        next
      end
      file.puts(line)
    }
  }  
  return true
end

def ids_to_lines()
  ids = make_ids
  ans = make_lines.select{|it|
    ids.include?(it[:line_id]) 
  }
  return ans
end

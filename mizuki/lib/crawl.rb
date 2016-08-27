class Crawl
  require File.expand_path('../', __FILE__) + '/prof.rb'
  
  attr_accessor :profs

  def initialize(ary)
    @profs = []
    ary.each{|l|
      @profs << Prof.new(l[0], l[1], l[2], l[3])
    }
    @profs.each{|x|
      x.diff
    }    
  end

  def koshin_list
    res = []
    self.profs.each{|prof|
      if prof.diff
        res << prof
      end
    }
    return res
  end
  
end

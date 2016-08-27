# coding: utf-8
class Prof
  require 'open-uri'
  
  attr_accessor :id, :url, :name, :prev, :title

  def initialize(id, name, url, title)
    @id = id
    @url = url
    @name = name
    @title = title
    @prev = nil
  end

  def path # 使わない
    base = File.expand_path('../../files/', __FILE__)
    return base + '/' + self.id + '.html'
  end

  def diff
    if self.prev.nil?
      open(self.url) {|input|
        self.prev = input.read
      }
      sleep(1)
      return false
    end
    res = false
    forward = ""
    open(self.url) {|input|
      forward = input.read
      res = (self.prev != forward)
    }
    self.prev = forward
    sleep(1)
    return res
  end

  def str
    return "#{self.name}先生の「#{self.title}」が更新されました。 #{self.url}"
  end
  
end

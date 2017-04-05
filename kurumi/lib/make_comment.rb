# coding: utf-8

require File.expand_path("../ignore.rb", __FILE__)

def make_comment_slack() # Slack に日程を書き込む用。全くこの bot では使わない。
  @kobanashi.sort_by{|item|
    item[1]
  }.each{|item|
    id = item[0]
    day = item[1]
    name = @nameplate[id]
    puts "#{day.strftime("%m/%d")} #{name} @#{id}"
  }  
end


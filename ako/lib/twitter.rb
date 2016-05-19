# coding: utf-8
require File.expand_path('../ignore.rb', __FILE__)
require 'twitter'

def tweets()
  client = Twitter::REST::Client.new(TW_CONFIG)
  return client.search("#utmsks -rt").take(50)  
end

def every_minutes(lasttime)
  ret = tweets().select{|tw|
    tw.created_at > lasttime
  }
  if !ret.empty?
    return ret.reverse, tweets.first.created_at
  end
  return ret.reverse, lasttime
end

def get_last_time()
  tw = tweets()
  if tw.empty?
    return Time.now
  end
  return tw.first.created_at
end

def slack_escape(str)
  ans = str
  chars = ['>', '\\`', '_', '\\*', '~', ':']
  chars_r = ['>', '`', '_', '*', '~', ':']
  chars.size.times{|i|
    ch = chars[i]
    ch_r = chars_r[i]
    ans = ans.gsub(/#{ch}/, " #{ch_r} ") # strは凍結状態かもしれない
  }
  ans = ans.gsub(/\s(?=\s)/, '')
  return ans
end

def saying(tweet)
  user = tweet.user
  return ":mag_right: #{slack_escape(user.name)} (@#{user.screen_name}): #{slack_escape(tweet.text)} #{tweet.url.to_s}"
end

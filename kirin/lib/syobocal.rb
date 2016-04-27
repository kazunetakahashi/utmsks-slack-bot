# coding: utf-8
# https://github.com/xmisao/syobocal/blob/master/bin/anime を参考にした。

require 'syobocal'
require 'active_support/all'

def format_time(time)
  h = time.hour
  h += 24 if h < 5
  m = time.min
  return sprintf("%02d:%02d", h, m)
end

def format_daytime(time)
  day = time
  day = day - 1.days if time.hour < 5
  return day.strftime("%m/%d(#{%w(日 月 火 水 木 金 土)[day.wday]}) ") + format_time(time)
end

@ch_tokyo = [
  1, # NHK総合
  2, # NHK Eテレ
  3, # フジテレビ
  4, # 日本テレビ
  5, # TBS
  6, # テレビ朝日
  7, # テレビ東京
  19, # TOKYO MX
]

@ch_metro = [
  1, # NHK総合
  2, # NHK Eテレ
  3, # フジテレビ
  4, # 日本テレビ
  5, # TBS
  6, # テレビ朝日
  7, # テレビ東京
  19, # TOKYO MX
  8, # TVK
  13, # チバテレビ
  14, # テレ玉
]

@ch_bs = [
  9, # NHK-BS1
  10, # NHK-BS2
  15, # BS Japan
  16, # BS-TBS
  17, # BSフジ
  18, # BS朝日
  71, # BS日テレ
  128, # BS11デジタル
  179, # NHK BSプレミアム
]

def syobocal_get(days, channels)
  params = {"days" => days.to_s}
  result = Syobocal::CalChk.get(params)
  return result.select{|prog|
    channels.include?(prog[:ch_id])
  }
end

def syobocal_today_template(start_time, end_time)
  res = syobocal_get(1, @ch_tokyo)
  return res.select{|prog|
    start_time <= prog[:st_time] && prog[:st_time] <= end_time
  }.sort_by{|prog|
    prog[:st_time]
  }
end

def syobocal_today_morning()
  now = Time.now()
  start_time = Time.new(now.year, now.month, now.day, 7)
  end_time = Time.new(now.year, now.month, now.day, 12)
  return syobocal_today_template(start_time, end_time)
end

def syobocal_today_evening()
  now = Time.now()
  start_time = Time.new(now.year, now.month, now.day, 17)
  end_time = Time.new(now.year, now.month, now.day, 21, 45)
  return syobocal_today_template(start_time, end_time)
end

def syobocal_today_midnight()
  now = Time.now()
  start_time = Time.new(now.year, now.month, now.day, 21, 50)
  if 5 < now.hour || now > start_time
    start_time = now
  end
  end_day = now.hour < 5 ? now : now + 1.days
  end_time = Time.new(end_day.year, end_day.month, end_day.day, 5)
  return syobocal_today_template(start_time, end_time)
end

def syobocal_search(str)
  ans = [syobocal_get(7, @ch_metro), syobocal_get(7, @ch_bs)]
  return ans.each{|res|
    res.select!{|prog|
      prog[:title].include?(str)
    }.sort_by!{|prog|
      prog[:st_time]
    }
  }
end

def make_title(prog, need_day) # https://twitter.com/animekanto に合わせる
  if need_day
    res = format_daytime(prog[:st_time])
  else
    res = format_time(prog[:st_time])
  end
  res += " [#{prog[:ch_name]}] #{prog[:title]} "
  if !(prog[:count].nil? || prog[:count] <= 0)
    res += "#" + prog[:count].to_s
  end
  if prog[:sub_title] != ""
    res += "『#{prog[:sub_title]}』"
  end
  return res
end

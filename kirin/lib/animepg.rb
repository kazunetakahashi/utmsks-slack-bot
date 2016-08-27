# coding: utf-8

class AnimePG
  require 'syobocal'
  require 'active_support/all'
  
  CH_TOKYO = [
    1, # NHK総合
    2, # NHK Eテレ
    3, # フジテレビ
    4, # 日本テレビ
    5, # TBS
    6, # テレビ朝日
    7, # テレビ東京
    19, # TOKYO MX
  ]
  CH_TOKYO.freeze

  CH_METRO = [
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
  CH_METRO.freeze

  CH_BS = [
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
  CH_BS.freeze

  CAT = [
    1, # アニメ
    10, # アニメ(終了/再放送)
    7, # OVA
    8, # 映画
  ]

  FIELD = [
    "TID", "PID", "Title", "ShortTitle",
    "ChName", "ChiEPGName", "ChID",
    "ChGID", "OffsetA", "OffsetB",
    "Count", "SubTitleA", "SubTitleB",
    "Mark", "MarkW", "Flag", "FlagW",
    "StTimeU", "EdTimeU", "Revision",
    "LastUpdateU", "ConfFlag", "Cat",
  ]
  FIELD.freeze

  FIELD_TO_I = [
    :TID, :PID, :ChID, :ChGID, :OffsetA,
    :Count, :Flag, :FlagW, :Revision,
    :Cat, 
  ]
  FIELD_TO_I.freeze

  FIELD_TIME = [
    :StTimeU, :EdTimeU, :LastUpdateU
  ]
  FIELD_TIME.freeze

  KUGIRI = "]<!_?[>"
  KUGIRI.freeze

  @titlefmt = ""
  for i in 0..FIELD.size()-1
    s = FIELD[i]
    @titlefmt += "$(#{s})"
    if i < FIELD.size()-1
      @titlefmt += KUGIRI
    end
  end
  @titlefmt.freeze

  class << self
    
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

    def syobocal_rss2_get(days)
      params = {"days" => days.to_s,
                "titlefmt" => @titlefmt }
      res = []
      Syobocal::RSS2.get(params).each{|prg|
        prg = prg[:title].split(KUGIRI)
        ans = {}
        for i in 0...FIELD.size()
          s = FIELD[i].intern
          ans[s] = prg[i]
        end
        FIELD_TO_I.each{|fld|
          ans[fld] = ans[fld].to_i
        }
        FIELD_TIME.each{|fld|
          ans[fld] = Time.at(ans[fld].to_i)
        }
        res << ans
      }
      return res
    end

    def syobocal_get(days, channels)
      result = syobocal_rss2_get(days)
      return result.select{|prog|
        channels.include?(prog[:ChID]) && CAT.include?(prog[:Cat])
      }
    end

    def syobocal_today_template(start_time, end_time)
      res = syobocal_get(1, CH_TOKYO)
      return res.select{|prog|
        start_time <= prog[:StTimeU] && prog[:EdTimeU] <= end_time
      }.sort_by{|prog|
        prog[:StTimeU]
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
      if 5 > now.hour || now > start_time
        start_time = now
      end
      end_day = now.hour < 5 ? now : now + 1.days
      end_time = Time.new(end_day.year, end_day.month, end_day.day, 5)
      return syobocal_today_template(start_time, end_time)
    end

    def syobocal_search(str)
      ans = [syobocal_get(7, CH_METRO), syobocal_get(7, CH_BS)]
      return ans.each{|res|
        res.select!{|prog|
          prog[:Title].include?(str)
        }.sort_by!{|prog|
          prog[:StTimeU]
        }
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

    def make_title(prog, need_day) # https://twitter.com/animekanto にだいたい合わせる
      if need_day
        res = format_daytime(prog[:StTimeU])
      else
        res = format_time(prog[:StTimeU])
      end
      res += " [#{prog[:ChName]}] #{prog[:Title]} "
      if prog[:Flag] > 1
        res += "#{prog[:Mark]} "
      end
      if !(prog[:Count].nil? || prog[:Count] <= 0)
        res += "#" + prog[:Count].to_s
      end
      if prog[:SubTitleA] != ""
        res += "『#{prog[:SubTitleA]}』"
      end
      if (t = prog[:OffsetA]) != 0    
        char = ((t > 0) ? "遅れ" : "早く")
        res += "※#{format_time(prog[:StTimeU] - t.minutes)}より#{t.abs}分#{char}スタート"
      end
      return slack_escape(res)
    end

  end
  
end

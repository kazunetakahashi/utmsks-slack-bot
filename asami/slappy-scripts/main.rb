# coding: utf-8
# Slappy Examples
#
# # called when start up

@channel = '#random'

hello do
  puts 'successfly connected by asami'
  TrainLine::init()
  TrainLine::make_watching()
end

hear MYNAME do |event|
  if event.text.include?("一覧")
    if TrainLine.watching.size == 0
      say "監視対象の路線が1つもないなんて、そんな無茶苦茶な！", channel: event.channel
    else
      say "現在の運行状況は、私なら掌握可能です。", channel: event.channel
      TrainLine.watching.each{|line|
        say line.info, channel: event.channel
      }
    end
    next
  end
  key = event.text[/「(.*)」/, 1]
  if key.nil?
    key = event.text[/【(.*)】/, 1]
  end
  if key.nil?
    say "要求はないのですか？ キーワードが「」に入っていないなんて認められません！", channel: event.channel
  else
    lines = TrainLine::search_lines(key)
    if lines.size == 0
      say "Why? 「#{key}」を含む路線は見つかりません。", channel: event.channel
    elsif lines.size >= 2
      str = "「#{key}」という語を含む路線には、"
      lines.each{|line|
        str += "【#{line[:line_name]}】"
      }
      str += "があります。私なら100％答えられます！ 1つに絞ってまた聞いて下さい。"
      say str, channel: event.channel
    else
      if event.text.include?("追加")
        if TrainLine::add_id(lines.first[:line_id])
          TrainLine::make_watching()
          say "【#{lines.first[:line_name]}】を監視対象に追加しました。運行情報は完璧に頭に入れましたから。", channel: event.channel
          say TrainLine.new_id(lines.first[:line_id]).info(), channel: event.channel
        else
          say "That's no problem! 【#{lines.first[:line_name]}】は既に監視対象に入っています。", channel: event.channel
          say TrainLine.new_id(lines.first[:line_id]).info(), channel: event.channel
        end
      elsif event.text.include?("削除")
        if TrainLine::delete_id(lines.first[:line_id])
          TrainLine::make_watching()
          say "【#{lines.first[:line_name]}】を監視対象から削除しました。関東の運行状況は、私が仕切る！", channel: event.channel
        else
          say "That's no problem! 【#{lines.first[:line_name]}】は既に監視対象から外れています。", channel: event.channel
        end
      else
        say TrainLine.new_id(lines.first[:line_id]).info(), channel: event.channel
      end
    end
  end
end

schedule '0 3 * * *' do
  TrainLine::init()  
end

schedule '*/5 * * * *' do
  TrainLine.watching.each{|line|
    if line.isnormal
      line.refresh
      if !line.isnormal
        say line.info, channel: @channel
      end
    else
      recent = line.recent
      line.refresh
      if recent != line.recent
        say line.info, channel: @channel
      end
      if line.isnormal
        say "もうダイヤは乱れませんから。本来の完璧な運行に戻ります。", channel: @channel
      end
    end
  }
end

#
#
# # called when match message
# hear 'foo' do
#   puts 'foo'
# end
#
#
# # use regexp in string literal
# hear 'bar (.*)' do |event|
#   puts event.matches[1] #=> Event#matches return MatchData object
# end
#
#
# # event object is slack event JSON (convert to Hashie::Mash)
# hear '^bar (.*)' do |event|
#   puts event.channel #=> channel id
#   say 'slappy!', channel: event.channel #=> to received message channel
#   say 'slappy!', channel: '#general'
#   say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:'
# end
#
#
# # use regexp literal
# hear /^foobar/ do
#   say 'slappppy!'
# end

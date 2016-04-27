# coding: utf-8

hear MYNAME do |event|
  if event.text.include?("今日")
    res = syobocal_today_midnight()
    say "先輩、御用でしょうか。今日の深夜アニメの放送予定は、", channel: event.channel
    res.each{|prog|
      say make_title(prog, false), channel: event.channel
    }
    say "です。夜更かししないでください…です。", channel: event.channel
  else
    key = event.text[/「(.*)」/, 1]
    if key.nil? || key == ''
      say  "先輩、御用でしょうか。「」の中に検索したいアニメのタイトルを入れてくだされば、私が番組表を検索します。", channel: event.channel
    else
      ans = syobocal_search(key)
      if ans[0].empty? && ans[1].empty?
        say "ごめんなさいです、先輩。「#{key}」という作品は見つけられませんでした。はうぅ…", channel: event.channel
      else
        if !(ans[0].empty?)
          say "地上波では、", channel: event.channel
          ans[0].each{|prog|
            say make_title(prog, true), channel: event.channel
          }
        end
        if !(ans[1].empty?)
          say "BSでは、", channel: event.channel
          ans[1].each{|prog|
            say make_title(prog, true), channel: event.channel
          }
        end
        say "が放送されるそうです。私でも、先輩のお役に立てたでしょうか…？", channel: event.channel
      end
    end
  end
end

schedule '45 21 * * *' do
  res = syobocal_today_midnight()
  say "先輩、こんばんは。今日の深夜アニメの放送予定は、", channel: '#anime'
  res.each{|prog|
    say make_title(prog, false), channel: '#anime'
  }
  say "です。夜更かししないでください…です。", channel: '#anime'
end

schedule '45 6 * * 0,6' do
  res = syobocal_today_morning()
  say "おはようございます、先輩。今朝のアニメの放送予定は、", channel: '#anime'
  res.each{|prog|
    say make_title(prog, false), channel: '#anime'
  }
  say "です。休日も早起きしなきゃです…はぅぅ…", channel: '#anime'
end

schedule '45 16 * * *' do
  res = syobocal_today_morning()
  say "先輩、今晩のアニメの放送予定は、", channel: '#anime'
  res.each{|prog|
    say make_title(prog, false), channel: '#anime'
  }
  say "です。今日もあと少し、ファイトです！", channel: '#anime'
end

# Slappy Examples
#
# called when start up
hello do
  puts 'successfly connected by kirin'
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

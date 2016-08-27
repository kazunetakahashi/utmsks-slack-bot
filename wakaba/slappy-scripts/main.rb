# coding: utf-8
# Slappy Examples
#
# # called when start up

@animelist = nil

hello do
  puts 'successfly connected by wakaba'
end

@syosiki =
  [
    "`[new] from -- to`",
    "`[add] 「str」`",
    "`[delete] 「num」` (num を省略すると最後に)",
    "`[clear]`",
    "`[get]`",
    "`[str]`"
  ]

hear MYNAME do |event|
  if event.text.include?("[new]")
    /(\d\d\d\d) - (\d\d\d\d)/ =~ event.text
    from = $1.to_i
    to = $2.to_i
    ok = true
    [from, to].each{|num|
      if !(!num.nil? && num.is_a?(Integer) && 1963 <= num && num <= Time.now.year)
        ok = false
      end
    }
    if ok && (from <= to)
      @animelist = CV::AnimeList.new(from, to)
      say @animelist.to_s, channel: event.channel
    else
      say "List を作成できませんでしたわ〜", channel: event.channel
    end
  elsif event.text.include?("[add]")
    key = event.text[/「(.*)」/, 1]
    if !key.nil? && @animelist.is_a?(CV::AnimeList)
      res = @animelist.add_keyword(key)
      if !res
        say "「#{key}」に一致する候補数が多すぎて追加できませんでしたわ〜", channel: event.channel
      else
        say res, channel: event.channel
      end
    else
      say "キーワードを追加できませんでしたわ〜", channel: event.channel
    end
  elsif event.text.include?("[delete]")
    key = event.text[/「(.*)」/, 1]
    if @animelist.is_a?(CV::AnimeList)
      if key.nil?
        @animelist.delete_at()
      else
        @animelist.delete_at(key.to_i)
      end
      say @animelist.to_s, channel: event.channel
    else
      say "キーワードを削除できませんでしたわ〜", channel: event.channel      
    end
  elsif event.text.include?("[clear]")
    if @animelist.is_a?(CV::AnimeList)
      @animelist.clear()
      say @animelist.to_s, channel: event.channel
    else
      say "クリアできませんでしたわ〜", channel: event.channel      
    end    
  elsif event.text.include?("[get]")
    if @animelist.is_a?(CV::AnimeList)
      res = @animelist.get_common_actors()
      if res.nil?
        say "該当する声優さんを列挙できませんでしたわ〜", channel: event.channel
      else
        say "該当する声優さんが #{res.size} 人いらっしゃいましたわ〜", channel: event.channel
        res.each{|str|
          say ":arrow_down_small: " + str, channel: event.channel
        }
      end
    else
      say "情報取得できませんでしたわ〜", channel: event.channel      
    end
  elsif event.text.include?("[str]")
    if @animelist.is_a?(CV::AnimeList)
      say @animelist.to_s, channel: event.channel
    else
      say "List をまだ作っていませんわ〜", channel: event.channel      
    end 
  else
    say "命令書式は #{@syosiki.join("、 ")} ですわ〜", channel: event.channel
  end
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

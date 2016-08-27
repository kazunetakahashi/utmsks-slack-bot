# coding: utf-8

module CV
  require 'open-uri'
  require 'nokogiri'

  MAX_ANIMES = 10
  MAX_ACTORS = 10
  SLEEP_TIME = 1.0

  class Anime
    attr_accessor :id, :name, :yomi, :year, :cours, :roles

    def initialize(id, name)
      self.name = name
      self.id = id
    end

    def url
      return "http://www.mau2.com/anime/" + id
    end

    def to_s
      return self.name
    end

    def get_roles()
      doc = Nokogiri::HTML(open(url))
      if !doc.xpath('//h1[@id="pgTitle"]').children[2].nil?
        self.yomi = doc.xpath('//h1[@id="pgTitle"]').children[2].text
      end
      doc.xpath('//a').each{|a|
        if a.attributes["href"].nil?
          next
        end
        str = a.attributes["href"].value
        if str.include?("/list/anime/date/")
          if !str[/\/list\/anime\/date\/([0-9]{4})/, 1].nil?
            self.year = str[/\/list\/anime\/date\/([0-9]{4})/, 1]
          end
          if !str[/\/list\/anime\/date\/([0-9]{4}[a-z])/, 1].nil?
            self.cours = str[/\/list\/anime\/date\/([0-9]{4}[a-z])/, 1]
          end
        end
      }
      self.roles = {}
      doc.xpath('//table[@class="animeCasts list exdingbats"]//tr').each{|role|
        play = role.children[0].text
        tmp = role.children[0].children[0].attributes["class"]
        if (!tmp.nil?) && tmp.value == "anonymous"
          play = "(役名なし)"
        end
        if play == "役" && name == "声優"
          next
        end
        tag = nil
        if !role.children[1].children[0].attributes["href"].nil?
          tag = role.children[1].children[0].attributes["href"].value[/\/voice\/(.*)/, 1]
        end
        if tag != nil
          if self.roles.has_key?(tag)
            self.roles[tag][:play] << play
          else
            self.roles[tag] = { anime: self, play: [play] }
          end
        end
      }
      return self.roles
    end
    
  end

  class AnimeList
    attr_accessor :from, :to, :animes, :animekeys, :actors, :valid

    def initialize(from, to)
      self.from = from
      self.to = to
      self.animes = []
      for i in from..to
        self.animes.concat(AnimeList.get_by_year(i))
        sleep(SLEEP_TIME)
      end
      self.valid = false
    end

    def clear()
      self.animekeys = nil
      self.actors = nil
      self.valid = false
    end

    def delete_at(*a)
      if self.animekeys.nil?
        return nil
      else
        if a.nil?
          self.animekeys.delete_at(a)
        else
          self.animekeys.delete_at(-1)
        end
        return self.to_s
      end
    end

    def AnimeList.get_by_year(year)
      url = "http://www.mau2.com/list/anime/date/" + year.to_s
      doc = Nokogiri::HTML(open(url))
      ans = []
      doc.xpath('//ul[@class="animeListItems noSprite"]//li//a').each{|src|
        id = src.attributes["href"].value[/\/anime\/(.*)/, 1]
        anime = Anime.new(id, src.text)
        ans << anime
      }
      return ans
    end

    def keyword(key)
      res = AnimeKeyword.new(key)
      res.animes = self.animes.select{|anime|
        anime.name.include?(key)
      }
      res.valid = (res.animes.size() <= MAX_ANIMES)
      return res
    end

    def add_keyword(key)
      if animekeys.nil?
        self.animekeys = []
      end
      a = keyword(key)
      if a.valid
        a.make_roles()
        self.animekeys << a;
        return a.to_s
      else
        return false
      end
    end

    def common_actors()
      if animes.nil? || animes.empty? || animekeys.nil? || animekeys.empty?
        return self.valid = false
      end
      actor_ids = self.animekeys.first.roles.keys
      self.animekeys.each{|list|
        actor_ids &= list.roles.keys
      }
      self.actors = []
      if self.valid = (actor_ids.size() <= MAX_ACTORS)
        actor_ids.each{|temp|
          self.actors << Actor.new(temp)
          sleep(SLEEP_TIME)
        }
      end
    end

    def get_common_actors()
      common_actors()
      res = []
      if !self.valid
        return nil
      end
      actors.each{|actor|
        str = "#{actor} : "
        for i in 0..animekeys.size()-1
          animekeys[i].roles[actor.id].each{|role|
            anime_title = role[:anime].to_s
            play_title = role[:play].join("、")
            str += "#{play_title} (#{anime_title}) "
          }
          if i < animekeys.size()-1
            str += "；"
          end
        end
        res << str
      }
      return res
    end

    def to_s
      str = "#{from} -- #{to} 年："
      if !animekeys.nil?
        animekeys.each{|key|
          str += "「#{key.keyword}」"
        }
      end
      return str
    end

  end

  class AnimeKeyword < AnimeList
    attr_accessor :keyword, :roles

    def initialize(key)
      self.keyword = key
      self.valid = false      
    end

    def make_roles()
      if self.animes.nil?
        return false
      end
      self.roles = {}
      self.animes.each{|anime|
        anime.get_roles().each{|key, role|
          if self.roles.has_key?(key)
            self.roles[key] << role
          else
            self.roles[key] = [role]

          end
        }
        sleep(SLEEP_TIME)
      }
      return true
    end

    def to_s
      return "「#{keyword}」 #{animes.size()} 件"
    end
    
  end
  
  class Actor
    attr_accessor :id, :name, :yomi

    def initialize(id)
      self.id = id
      doc = Nokogiri::HTML(open(self.url))
      doc.xpath('//h1//span').each{|ele|
        if (!ele.attributes["class"].nil?) && ele.attributes["class"].value == "yomi"
          self.yomi = ele.children[0].text
          if self.yomi.include?("(")
            self.yomi = self.yomi[/(.*)\(.*\)/, 1]
          end
        end
        if (!ele.attributes["itemprop"].nil?) && ele.attributes["itemprop"].value == "name"
          self.name = ele.children[0].text
        end
        if (!self.name.nil?) && self.name != ""
          break
        end
      }
      if self.name.nil?
        self.name == ""
      end
      if self.yomi.nil?
        self.yomi == ""
      end
    end

    def url
      return "http://www.mau2.com/voice/" + id
    end

    def to_s
      str = self.name
      if !(yomi.nil?) && (yomi != "")
        str += " (#{yomi})"
      end
      return str
    end
    
  end

  
end

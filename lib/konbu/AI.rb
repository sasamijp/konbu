# coding: utf-8
require 'sqlite3'

module Konbu

  class AI

    def initialize(name, nameJP, responds)
      @responds = responds
      @name = name
      @nameJP = nameJP
    end

    def respond(text)
      input = extractKeyWords(text)
      return nil if input.nil?

      hitwords = @responds.select{ |value| wordsMatch(value[1].split(","), input) != 0 }
      hitwords.sort_by!{ |value| wordsMatch(value[1].split(","), input) }
      hitwords.map!{ |value| value = value[0] }

      return hitwords[0]
    end

    def save
      db = SQLite3::Database.new("./#{@name}.db")
      
    end

    private

    def wordsMatch(words1, words2)
      match = 0
      words1.each do |word1|
        words2.each do |word2|
          match += 1 if word1 == word2
        end
      end
      return match.to_f/words1.length.to_f
    end

    def extractKeyWords(str)
      return nil if str == nil
      nm = Natto::MeCab.new
      nouns = []
      nm.parse(str) do |n|
        nouns.push(n.surface)
      end
      data = []
      nouns.each_with_index do |noun,l|
        next if l == 0
        data.push(["#{nouns[l-1]}#{noun}", "#{noun}#{nouns[l+1]}"])
      end

      result = []
      data.flatten.each do |dat|
        isInclude = false
        nm.parse(dat) do |n|
          type = n.feature.split(",")[0]
          case type
          when "名詞", "動詞"
            isInclude = true
          end
        end
        result.push(dat) if isInclude
      end
      return result
    end

  end

end

# coding: utf-8

require 'sqlite3'
require 'konbu/keywordExtractor'
require 'konbu/Saver'

module Konbu

  class AI

    def initialize(name, nameJP, responds)
      @tractor = KeywordExtractor.new
      @saver = Saver.new
      @responds = responds
      @name = name
      @nameJP = nameJP
    end

    def addResponds(responds)
      responds.each do |respond|
        @responds << respond
      end
    end

    def respond(text)
      input = @tractor.extract(text)
      return nil if input.nil?
      hitwords = @responds.select{ |value| wordsMatch(value[1].split(","), input) != 0 }
      hitwords.sort_by!{ |value| wordsMatch(value[1].split(","), input) }
      hitwords.map!{ |value| value = value[0] }
      return hitwords[0]
    end

    def save
      @saver.newRespondDB(@name)
      @saver.insertNames(@name, @name, @nameJP)
      @saver.insertRespond(@name, @responds)
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

  end

end

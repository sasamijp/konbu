# -*- encoding: utf-8 -*-


require 'sqlite3'
require 'konbu/keywordExtractor'
require 'konbu/Saver'

module Konbu

  class Intelligence

    def initialize(name, name_jp, responds)
      @tractor = KeywordExtractor.new
      @saver = Saver.new
      @responds = responds
      @name = name
      @name_jp = name_jp
    end

    def add_responds(responds)
      responds.each do |respond|
        @responds << respond
      end
    end

    def respond(text)
      input = @tractor.extract(text)
      #p input
      return nil if input.nil?
      hitwords = @responds.select{ |value| words_match(value[1], input) != 0 }
      #p hitwords
      hitwords.sort_by!{ |value| words_match(value[1], input) }
      #hitwords.map!{ |value| value = value[0] }
      hitwords[0]
    end

    def save
      @saver.new_respond_db(@name)
      @saver.insert_names(@name, @name, @name_jp)
      @saver.insert_responds(@name, @responds)
    end

    private

    def words_match(words1, words2)
      return 0 if words1.length == 0
      match = 0
      words1.each do |word1|
        words2.each do |word2|
          match += 1 if word1 == word2
        end
      end
      match
    end

  end

end

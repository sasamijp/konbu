# -*- encoding: utf-8 -*-
require 'natto'

module Konbu

  class KeywordExtractor

    def initialize
      @nm = Natto::MeCab.new
    end

    def extract(str)
      return nil if str == nil
      join_words(wakati(str))[0..-2]
    end

    private

    def wakati(str) 
      array = []
      @nm.parse(str) do |n|
        array.push(n.surface)
      end
      array
    end

    def join_words(nouns)
      array = []
      nouns.each_with_index do |noun,l|
        begin
          nouns[l-1]
          nouns[l+1]
        rescue; next; end
        array << %W(#{nouns[l-1]}#{noun} #{noun}#{nouns[l+1]})
      end
      array.flatten
    end

  end

end

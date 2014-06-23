# -*- encoding: utf-8 -*-
require 'natto'

module Konbu

  class KeywordExtractor

    def initialize
      @nm = Natto::MeCab.new
    end

    def extract(str)
      return nil if str == nil
      join_words(wakati(str))
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
      data = []
      nouns.each_with_index do |noun,l|
        next if l == 0
        begin
          data << [nouns[l-1]+noun, noun+nouns[l+1]]
        rescue; break; end
      end
      data.flatten
    end

  end

end

# -*- encoding: utf-8 -*-
require 'natto'

module Konbu

  class keywordExtractor

    def initialize
      @nm = Natto::MeCab.new
    end

    def extract(str)
      return nil if str == nil
      return joinwords(wakati(str))
    end

    private

    def wakati(str) 
      array = []
      @nm.parse(str) do |n|
        array.push(n.surface)
      end
      return array
    end

    def joinWords(nouns)
      data = []
      nouns.each_with_index do |noun,l|
        next if l == 0
        data.push(["#{nouns[l-1]}#{noun}", "#{noun}#{nouns[l+1]}"])
      end
      return data
    end

  end

end

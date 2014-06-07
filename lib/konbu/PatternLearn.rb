# -*- encoding: utf-8 -*-

require 'natto'
require 'extractcontent'
require 'open-uri'
require 'parallel'
require 'konbu/URLcollector'
require 'konbu/SSparser'

module Konbu

  class PatternLearn

    def initialize(name, pagecount)
      @urlCollector = URLcollector.new
      @parser = SSparser.new
      @name = name
      @respond = []
      @pagecount = pagecount
    end

    def learn
      @urlCollector.collect(@name, @pagecount).each do |url|
        next if url.include?("2chmoeaitemu")
        parsed = @parser.parse(url)
        next if parsed.nil?
        parsed.each do |hash|
          next if hash['name'] != @name
          @respond.push [hash['serif'], extractKeyWords(hash['in_reply_to'])]
        end
      end
      return @respond
    end

    private

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

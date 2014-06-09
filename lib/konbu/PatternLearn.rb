# -*- encoding: utf-8 -*-

require 'natto'
require 'extractcontent'
require 'open-uri'
require 'parallel'
require 'konbu/URLcollector'
require 'konbu/SSparser'
require 'konbu/keywordExtractor'

module Konbu

  class PatternLearn

    def initialize(name, pagecount)
      @urlCollector = URLcollector.new
      @parser = SSparser.new
      @tractor = KeywordExtractor.new
      @name = name
      @pagecount = pagecount
    end

    def autoLearn
      parsed = @parser.parseURLs(@urlCollector.collect(@name, @pagecount))
      return nil if parsed.nil?
      return learn(parsed)
    end

    def txtLearn(filename)
      parsed = @parser.parse(filename)
      return nil if parsed.nil?
      return learn(parsed)
    end

    private

    def learn
      responds = []
      parsed.each do |thread|
        thread.each do |hash|
          next if hash['name'] != @name
          responds.push [hash['serif'],  @tractor.extract(hash['in_reply_to'])]
        end
      end
      return responds.delete_if{|respond| respond[0].nil? or respond[1].nil? }
    end

  end

end

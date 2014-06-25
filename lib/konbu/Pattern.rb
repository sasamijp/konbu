# -*- encoding: utf-8 -*-

require 'natto'
require 'extractcontent'
require 'open-uri'
require 'parallel'
require 'konbu/URLcollector'
require 'konbu/SSparser'
require 'konbu/keywordExtractor'

module Konbu

  class Pattern

    def initialize(name)
      @url_collector = URLCollector.new
      @parser = SSparser.new
      @tractor = KeywordExtractor.new
      @name = name
    end

    def auto_learn(pagecount)
      parsed = @parser.parse_urls(@url_collector.collect(@name, pagecount))
      return nil if parsed.nil?
      learn(parsed)
    end

    def txt_learn(filename)
      parsed = @parser.parse_txt(filename)
      return nil if parsed.nil?
      learn(parsed)
    end

    private

    def learn(parsed)
      responds = []
      parsed.each do |hash|
        next if hash['name'] != @name
        responds.push [hash['serif'],  @tractor.extract(hash['in_reply_to'])]
      end
      responds.delete_if{|respond| respond[0].nil? or respond[1].nil? }
    end

  end

end

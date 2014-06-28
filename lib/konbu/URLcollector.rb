# -*- encoding: utf-8 -*-

require 'open-uri'
require 'nokogiri'

module Konbu

  class URLCollector

    # name should be written in kanji or hiragana
    def collect(name, pagecount)
      urls = []
      collect_matome_urls(name, pagecount).each do |matome|
        urls.push extract_urls(matome)
      end
      urls.flatten
    end

    private

    def collect_matome_urls(name, pagecount)
      matomes = []
      for num in 1..pagecount do
        matomes.push('http://ssmatomeantenna.info/search.html?category='+URI.escape("#{name}「")+'&pageID='+"#{num}")
      end
      matomes
    end

    def extract_urls(url)
      page = URI.parse(url).read
      charset = page.charset
      html = (Nokogiri::HTML(page, url, charset))
      urls = []
      html.css('a').each do |str|
        str = str.to_s.encode('UTF-8', 'UTF-8')
        urls.push(str.split('"')[1]) if str.include?('「') and !str.include?('amazon')
      end
      urls
    end

  end

end

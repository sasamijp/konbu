# coding: utf-8
require 'open-uri'
require 'nokogiri'

module Konbu

  class URLcollector

    # name should be written in kanji or hiragana
    def collect(name, pagecount)
      collectmatomeURLs(name, pagecount).each do |matome|
        urls.push extractURLs(matome)
      end
      return urls
    end

  private

    def collectmatomeURLs(name, pagecount)
      matomes = []
      for num in 1..pagecount do
        matomes.push('http://ssmatomeantenna.info/search.html?category='+URI.escape("#{name}「")+'&pageID='+"#{num}")
      end
      return matomes
    end

    def extractURLs(url)
      page = URI.parse(url).read
      charset = page.charset
      html = (Nokogiri::HTML(page, url, charset))
      urls = []
      html.css('a').each do |str|
        str = str.to_s.encode("UTF-8","UTF-8")
        urls.push(str.split('"')[1]) if str.include?("「") and !str.include?("amazon")
      end
      return urls
    end

  end

end

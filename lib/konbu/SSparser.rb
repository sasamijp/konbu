# -*- encoding: utf-8 -*-

require 'bundler/setup'
require 'extractcontent'
require 'open-uri'

module Konbu

  class SSparser

    def extracter
      return ExtractContent.instance_methods()
    end

    def parse(url)
      ss = []
      target = nil
      body = extractBody(url)
      return nil if body == []
      body[0].split("\n").each do |str|
        next if (!str.include?("「") and !str.include?("」")) or isNamespace(str)
        hash = {
          "name" => whoIsTalking(str),
          "serif" => extractSerif(str),
          "in_reply_to" => target
        }
        target = extractSerif(str)
        ss.push hash
      end
      return ss.delete_if{|hash| hash['name'].nil? or hash['serif'].nil? or hash['in_reply_to'].nil?}
    end

    def extractBody(url)
      open(url) do |io|
        html = io.read
        body, title = ExtractContent::analyse(html)
        strs = []
        body.split("  ").each do |str|
          strs.push(str) if str.include?("「") and !isNamespace(str)
        end
        return strs
      end
    end

    def isNamespace(str)
      if str.length >= 54
        namespace = str[0..54]
        return (namespace.include?(":") and namespace.include?("/"))
      else
        return false
      end
    end

    def whoIsTalking(str)
      return str[0..str.rindex("「")-1] 
    end

    def extractSerif(str)
      name = whoIsTalking(str)
      return str.sub("「","").reverse.sub("」","").reverse.sub(name, "") 
    end

  end

end

#parser = SSparser.new
#p parser.parse("http://morikinoko.com/archives/51921724.html")

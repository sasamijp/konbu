# -*- encoding: utf-8 -*-

require 'bundler/setup'
require 'extractcontent'
require 'open-uri'

module Konbu

  class SSparser

    def parseTXT(filename)
      body = File.read(filename, :encoding => Encoding::UTF_8)
      body.gsub!("｢","「")
      body.gsub!("『","「")
      body.gsub!("｣","」")
      body.gsub!("』","」")
      return parse(body)
    end

    def parseURLs(*url)
      parsed = []
      urls = url
      urls.each do |url|
        body = extractBody(url)
        next if body == []
        parsed.push parse(body[0])
      end
      case parsed.length
      when 0
        return nil
      else
        return parsed
      end
    end

    private

    def parse(body)
      ss = []
      in_reply_to = nil
      body.split("\n").each do |str|
        next if (!str.include?("「") and !str.include?("」")) or isNamespace(str)
        hash = {
          'name' => whoIsTalking(str),
          'serif' => extractSerif(str),
          'in_reply_to' => in_reply_to
        }
        in_reply_to = hash['serif']
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
      begin
        return str[0..str.rindex("「")-1] 
      rescue
        return nil
      end
    end

    def extractSerif(str)
      name = whoIsTalking(str)
      return nil if name.nil?
      return str.sub("「","").reverse.sub("」","").reverse.sub(name, "") 
    end

  end

end

#parser = SSparser.new
#p parser.parse("http://morikinoko.com/archives/51921724.html")

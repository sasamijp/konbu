# -*- encoding: utf-8 -*-

require 'bundler/setup'
require 'extractcontent'
require 'open-uri'

module Konbu

  class SSparser

    def parse_txt(filename)
      body = File.read(filename, :encoding => Encoding::UTF_8)
      body.gsub!('｢', '「')
      body.gsub!('『', '「')
      body.gsub!('｣', '」')
      body.gsub!('』', '」')
      parse(body)
    end

    def parse_urls(urls)
      parsed = []
      urls.each do |url|
        body = extract_body(url)
        next if body == []
        parsed << parse(body[0])
      end
      return nil if parsed.length == 0
      parsed
    end

    private

    def parse(body)
      ss = []
      in_reply_to = nil
      body.split("\n").each do |str|
        next if (!str.include?('「') and !str.include?('」')) or namespace?(str)
        hash = {
          'name' => who_talking(str),
          'serif' => extract_serif(str),
          'in_reply_to' => in_reply_to
        }
        in_reply_to = hash['serif']
        ss.push hash
      end
      ss.delete_if{|hash| hash['name'].nil? or hash['serif'].nil? or hash['in_reply_to'].nil?}
    end

    def extract_body(url)
      open(url) do |io|
        html = io.read
        body, _ = ExtractContent::analyse(html)
        strs = []
        body.split('  ').each do |str|
          strs.push(str) if str.include?('「') and !namespace?(str)
        end
        return strs
      end
    end

    def namespace?(str)
      begin
        namespace = str[0..54]
        (namespace.include?(':') and namespace.include?('/'))
      rescue
        false
      end
    end

    def who_talking(str)
      begin
        str[0..str.rindex('「')-1]
      rescue
        nil
      end
    end

    def extract_serif(str)
      name = who_talking(str)
      return nil if name.nil?
      str.sub('「', '').reverse.sub('」', '').reverse.sub(name, '')
    end

  end

end

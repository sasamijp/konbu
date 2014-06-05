# coding: utf-8
require 'bundler/setup'
require 'extractcontent'
require 'open-uri'
require 'konbu/version'
require 'konbu/AI'
require 'konbu/URlCollector'
require 'konbu/SSparser'
require 'konbu/PatternLearn'

#pa = Konbu::SSparser.new
#p pa.parse("http://morikinoko.com/archives/51921724.html")

#co = Konbu::URLcollector.new
#p co.collect("春香", 1)

pl = Konbu::PatternLearn.new("春香", 1)
p pl.learn

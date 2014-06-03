# coding: utf-8

require 'konbu/version'
require 'konbu/AI'
require 'konbu/URlCollector'
require 'konbu/SSparser'
require 'konbu/PatternLearn'


pl = Konbu::PatternLearn.new("春香", 1)
p pl.learn


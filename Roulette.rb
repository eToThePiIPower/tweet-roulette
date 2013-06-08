#!/usr/bin/ruby

require 'Extractor'
require 'GetTwitterJSON'

json = GetTwitterJSON::getByHashtag(ARGV[0])

e = Extractor.new(json)
puts e.extract_urls

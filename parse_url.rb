#!/usr/bin/env ruby

require 'url_parser'

def usage
  puts "Usage: parse_url.rb url"
  exit
end

if ARGV[0].nil? || ARGV[0].empty?
  usage
else
  parsed_url = UrlParser.new(ARGV[0])

end

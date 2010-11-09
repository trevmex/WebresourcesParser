#!/usr/bin/env ruby

require 'nokogiri'
require './url_parser'

class WebresourcesParser
  attr_accessor :webresources, :base_url, :urls, :parsed_urls

  def initialize(webresources_file, base_url = "")
    self.webresources = Nokogiri::XML(File.read(webresources_file))
    self.base_url     = base_url
    self.urls         = webresources.xpath("/webresources/webpage/url").children
    self.parsed_urls  = []

    parse
  end

  def parse
    urls.each do |url_list|
      puts "\  '#{url_list.content.split(",")[0]}\',"
      #next if /\*/.match(url) || /\.widget$/.match(url) || /\.script$/.match(url) || /\.htmlf$/.match(url)
      #
      #parsed_urls << UrlParser.new(url).parse
    end
  end
end

parsed_webresources = WebresourcesParser.new("/Users/tmenag200/Documents/Aptana Studio Workspace/trunk/webapp/cTV/src/main/resources/webresources.xml", "http://local.fancast.com:8080")

#!/usr/bin/env ruby

require './url_parser'

module Enumerable
  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end
end

base_url = "http://www.fancast.com"

selectors = []

[
  '/',
  '/sweepstakes',
  '/home',
  '/movies',
  '/full_episodes',
  '/mytv/main',
  '/mytv/watchlists/watchlist',
  '/mytv/updates',
  '/mytv/list',
  '/mytv/tivo',
  '/mytv/dvr',
  '/mytv/friends',
  '/mytv/settings',
  '/myinfo',
  '/computer',
  '/tv-episode-listings',
  '/tv-listings',
  '/tv-listings/search/',
  '/tv-listings/xfinity/wall',
  '/comcast-tv-listings',
  '/national-tv-listings',
  '/trailers',
  '/clips',
  '/premierweek',
  '/info/about',
  '/info/terms',
  '/info/terms.widget',
  '/info/privacy',
  '/info/privacy.widget',
  '/info/new_terms',
  '/info/new_privacy_policy',
  '/info/network_partners',
  '/info/contact',
  '/tv-networks',
  '/tv-networks/ABC/109/main',
  '/movies/Jelly/155899/1464430233/Jelly/videos',
  '/tv/The-Talk/140949/about',
  '/movies-on-tv',
  '/movies/Jelly/155899/full-movie',
  '/movies/The-Green-Hornet/148936/clips',
  '/tv/The-Talk/140949/episodes',
  '/ondemand',
  '/ondemand/browse'
].each do |url|
  next if /\*/.match(url) || /\.widget$/.match(url) || /\.script$/.match(url) || /\.htmlf$/.match(url)

  puts "Parsing #{url}"
  url_parser = UrlParser.new("#{base_url}#{url}")
  selectors << url_parser.parse_style
end

result_set = selectors.first.dup

selectors.each do |selector_list|
  result_set = (selector_list + result_set).dups
end

require 'pp'

pp result_set

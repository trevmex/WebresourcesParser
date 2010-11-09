require 'uri'
require 'open-uri'
require 'nokogiri'
require 'css_parser'
require 'rest-client'

class UrlParser
  attr_accessor :classes, :html, :ids, :links, :unused_selectors, :url, :used_selectors
  
  def initialize(url)
    self.url = URI.parse(url)

    parse_url
  end
  
  def parse_url
    begin
      response = RestClient.get(url.to_s)

      unless (response.nil? || response.empty?)
        self.html = Nokogiri::HTML(response.body) 

        self.links = parse_links
        self.ids = parse_ids
        self.classes = parse_classes
      end
    rescue
      STDERR.puts "Couldn't get page '#{url}'"
    end
  end

  def parse_style
    self.used_selectors   = [] unless defined?(@used_selectors)
    #self.unused_selectors = [] unless defined?(@unused_selectors)

    links.each do |link|
      style_url = set_url_defaults(URI.parse(link.content))

      style = CssParser::Parser.new
      style.load_uri!(style_url.to_s)

      style.each_selector do |selector, declarations, specificity|
        next unless selector =~ /^[\d\w\s\#\.\-]*$/ # Some of the selectors given by css_parser aren't actually selectors.
        
        begin
          element = html.css(selector)
          
          if element.length > 0
            self.used_selectors << selector
            
            #{:selector     => selector,
            # :declarations => declarations,
            # :specificity  => specificity,
            # :frequency    => element.length}
          end
          #if element.length == 0
          #  self.unused_selectors
          #else
          #  self.used_selectors
          #end << {:selector     => selector,
          #        :declarations => declarations,
          #        :specificity  => specificity,
          #        :frequency    => element.length}
        rescue
          STDERR.puts "Couldn't parse selector '#{selector}'"
        end
      end
    end

    self.used_selectors   = self.used_selectors.uniq
    #self.unused_selectors = self.unused_selectors.uniq

    #[self.used_selectors, self.unused_selectors]
  end

  private

  def parse_links
    find("//link/@href").delete_if do |link|
      !(/\.css$/.match(link.content))
    end
  end

  def parse_ids
    find("//@id")
  end

  def parse_classes
    find("//@class")
  end

  def find(pattern)
    html.xpath(pattern).to_a.uniq
  end

  def set_url_defaults(new_url)
    ["scheme", "host", "port"].each do |component|
      new_url.send("#{component}=", url.send("#{component}")) if (new_url.send("#{component}").nil? || new_url.send("#{component}").empty?)
    end

    new_url
  end
end

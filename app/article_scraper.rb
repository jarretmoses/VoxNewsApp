require 'nokogiri'
require 'open-uri'

class ArticleScraper
  attr_reader :format
  
  def scrape_latest(link,css)
    data = Nokogiri::HTML(open("#{link}"))
    data.css("#{css}")
  end

  def scrape_article(link,css)
    Nokogiri::HTML(open(link)).css("#{css}").text
  end


end
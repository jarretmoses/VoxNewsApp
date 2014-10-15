require 'pry'
require 'nokogiri'
class VoxNews
  attr_reader :articles
  def initialize
    @link = 'http://www.vox.com'
    @css = 'ul.m-hp-latest__list li'
    @article_css = 'div.m-entry__body p'
    @articles = ArticleScraper.new.scrape_latest(@link,@css)
  end

  def run
    list_latest_news
    puts
    command = ''
    while command != 'exit'
    print "Enter command (type 'help' for help): "
    command = gets.strip

     case command
       when /read/
        cmd = command.gsub('read ','')
        read_article(cmd)
       when 'exit'
          puts "Goodbye"
       when 'help'
          help
       when 'list'
        list_latest_news
       when /open/
        cmd = command.gsub('open ','')
        open_article(cmd)
     end

    end
  end

  def read_article(article)
    if article.length == 0
      puts "Please enter article number."
      puts
      list_latest_news
      puts
      article = gets.strip
    end
    article = @articles[article.to_i-1].css('a')[0].attribute("href").value
    puts
    puts """
                               ARTICLE START
-------------------------------------------------------------------------------
"""
    puts ArticleScraper.new.scrape_article(article,@article_css)
    puts """
                              
-------------------------------------------------------------------------------
                                ARTICLE END
"""
puts
  end

  def open_article(article)
    if article.length == 0
      puts "Please enter article number."
      puts
      list_latest_news
      puts
      article = gets.strip
    end
    site = @articles[article.to_i-1].css('a')[0].attribute("href").value

    system("open #{site}")
  end

  def list_latest_news
    puts """
                         The Latest News on VOX
-------------------------------------------------------------------------------
    """
    @articles = ArticleScraper.new.scrape_latest(@link,@css)
    articles.each_with_index do |story,index|
      puts "#{index+1}.#{story.css('a').text}"
    end
  end

  def help
    puts """
      'list' - lists latest story lines
      'read  <article number>' prints the article.
      'open  <article number>' opens the article in default browser.
      'exit' - exits program
    """
  end


end
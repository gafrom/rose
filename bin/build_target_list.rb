require_relative './bootstrap.rb'
require 'crawl100_sp'
require 'open-uri'

initial_url = 'http://www.100sp.ru/vladivostok/purchase/recently'
links_sources = []

1.upto(Crawl100Sp::TOTAL_PAGES) do |page_num|
  links_sources << "#{initial_url}?page=#{page_num}"
end

links_sources.each do |url|
  puts "Get links from url: #{url}"
  Crawl100Sp.store_target_links(
    Pathname.new(PROJECT_ROOT).join('data','target_links.csv'),
    Crawl100Sp.parse_target_links(open(url).read)
  )
end

require_relative './bootstrap.rb'
require 'crawl100_sp'
require 'open-uri'

link_source = [
  'http://www.100sp.ru/vladivostok/purchase/recently'
]

link_source.each do |url|
  puts "Get links from url: #{url}"
  Crawl100Sp.store_target_links(
    Pathname.new(PROJECT_ROOT).join('data','target_links.csv'),
    Crawl100Sp.parse_target_links(open(url).read)
  )
end

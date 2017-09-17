require_relative './bootstrap.rb'
require 'csv'
require 'pathname'
require 'open-uri'
require 'uri'
require 'crawl100_sp'

target_links = CSV.read(
  PROJECT_ROOT.join('data','target_links.csv')
).uniq

data_file = PROJECT_ROOT.join('data','data.pstore')

target_links.each do |row|
  link = row.first
  url = URI('http://www.100sp.ru').tap {|o| o.path = link }.to_s
  puts "Get data from url: #{url}"
  Crawl100Sp.store_target_data(
    data_file,
    link,
    Crawl100Sp.parse_target_data(open(url).read)
  )
end

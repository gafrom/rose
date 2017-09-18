require_relative './bootstrap.rb'
require 'pstore'

data_file = PROJECT_ROOT.join('data','data.pstore')
output_file = PROJECT_ROOT.join('data','data.csv')
storage = PStore.new data_file

headers = storage.transaction { storage[:documents].first[1].keys }

File.open(output_file, 'w:utf-8') do |io|
  io.write "Purchase ID, #{headers.join(',')}\n"

  storage.transaction do
    storage[:documents].each do |purchase_id, purchase_data|
      csv = [purchase_id]
      csv += purchase_data.values.map do |v|
        cleaned = v.gsub(/\r/, ' ').gsub(/\n/, ' ').gsub(/\s\s+/, ' ')
        "'#{cleaned}'"
      end

      io.write "#{csv.join(',')}\n"
    end
  end
end

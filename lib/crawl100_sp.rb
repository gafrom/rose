require 'nokogiri'
require 'pstore'
module Crawl100Sp
  class << self
    def store_target_links(path, links)
      file = File.open(path, 'a+')
      links.each do |line|
        file.puts line
      end
      file.close
    end

    def parse_target_links(data)
      raise 'Document is empty' if data.nil? || data.empty?

      list = Nokogiri::HTML(data).css('li.purchases-list-item div.purchase-link a')
      list.map {|o| o['href']}
    end

    def store_target_data(path, url, data)
      storage = PStore.new(path)
      storage.transaction do
        storage[:documents] ||= {}
        storage[:documents][url] = data
      end
    end

    def parse_target_data(data)
      raise 'Document is empty' if data.nil? || data.empty?
      # parse from JS
      city = data.match(/<span id="purchase-city">(.*)<\//).to_a[1]

      doc = Nokogiri::HTML(data)
      {
        city: city,
        title: doc.css('h1.h1-purchase').text.strip,
        purchase_type: doc.css('div.purchase-badge span.purchase_type.ptype6').text.strip,
        status_badge: doc.css('div.purchase-badge.purchase-status-badge').text.strip,
        org_name: doc.css('span.purchase-org-name a').children.first.text,
        org_rating: doc.css('span.org-rating.full').text.strip,


      }.merge(
        [:book_before, :pay_before, :fee, :delivery_date, :goods_amount].zip(
          doc.css('table.fox-table-clean.fox-table13.fox-table-clean-single.simple-table.key-info-table td').map {|o| o.text.strip }
        ).to_h
      ).merge(
        [:org_city, :org_date_from].zip(
        doc.css('div.purchase-org-top div').text.strip.lines.map(&:strip)
      ).to_h
      ).merge(
        [:subscribers,:purchases].zip(
        doc.css('td.td-purchase-subs-item small strong').map(&:text).map(&:strip)
      ).to_h
      )
    end
  end
end

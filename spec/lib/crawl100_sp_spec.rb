require 'spec_helper'
require 'crawl100_sp'
require 'tempfile'

describe Crawl100Sp do
  subject { described_class }

  it { is_expected.to respond_to(:store_target_links).with(2).arguments }
  it { is_expected.to respond_to(:parse_target_links).with(1).argument }
  it { is_expected.to respond_to(:store_target_data).with(2).argument }
  it { is_expected.to respond_to(:parse_target_data).with(1).argument }

  describe '.store_target_links' do
    let(:path) { Tempfile.new('test_target_links').path }
    let(:links) do
      [
          '/purchase/510620',
          '/purchase/510584'
      ]
    end

    let(:expected_file_content) do
      "/purchase/510620\n/purchase/510584\n"
    end

    before do
      described_class.store_target_links(path, links)
    end
    subject { File.read(path) }

    it { is_expected.to eq expected_file_content }
  end

  describe '.store_target_data' do
    before do
      described_class.store_target_data(path, data)
    end
  end

  describe '.parse_target_links' do
    subject { described_class.parse_target_links(page_content) }

    context 'when content empty' do
      let(:page_content) { '' }
      it { expect { subject }.to raise_error 'Document is empty' }
    end

    context 'when content with links' do
      let(:page_content) { File.read(PROJECT_ROOT.join('spec','fixtures','files','recently_page.html')) }
      let(:included_links) do
        [
          '/purchase/510620',
          '/purchase/510584',
          '/purchase/510547',
          '/purchase/510443'
        ]
      end
      let(:links_amount) { 20 }

      it { is_expected.to be_a Array }
      it { is_expected.to have(links_amount).items }
      it 'should include links' do
        included_links.map do |link|
          is_expected.to include link
        end
      end
    end
  end

  describe '.parse_target_data' do
    subject { described_class.parse_target_data(page_content) }
    context 'when content is empty' do
      let(:page_content) { nil }
      it { expect { subject }.to raise_error 'Document is empty' }
    end

    context 'when document with data' do
      let(:page_content) { File.read(PROJECT_ROOT.join('spec','fixtures','files','content_page.html')) }
      let(:expected_data) do
        {
          city: 'Владивосток',
          title: 'Hot Sale ♥ Свитшоты ♥ от 299 руб ♥ Стильные ♥ Модные ♥ Успей',
          purchase_type: 'China',
          status_badge: 'обработка',
          org_name: 'Cosmopolitan',
          org_rating: '14.6',
          book_before: 'До 14.09.2017 в 23:00',
          pay_before: 'До 24.09.2017',
          fee: "0%\n                            Включено в цену",
          delivery_date: '24.10.2017',
          goods_amount: '135 товаров',
          org_city: 'Владивосток',
          org_date_from: 'На сайте с 06.12.2013',
          subscribers: '8894',
          purchases: '102'
        }
      end

      it { is_expected.to be_an Hash }
      it { is_expected.to include expected_data }
    end
  end
end

require 'spec_helper'
require 'list_parser'

describe ListParser do
  let(:data) { }
  let(:parser) { described_class.new(data) }
  subject { parser }

  it { is_expected.to respond_to(:parser) }
end

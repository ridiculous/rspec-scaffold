$:.unshift File.expand_path('../../../../', __FILE__)
require 'rails_helper'

describe RSpec::Scaffold::Generator, type: :rails_integration do
  let(:file) { FIXTURE_ROOT.join('report.rb') }

  subject { described_class.new file }

  describe '#helper_file' do
    it 'returns "rails_helper"' do
      expect(subject.helper_file).to eq 'rails_helper'
    end
  end

end

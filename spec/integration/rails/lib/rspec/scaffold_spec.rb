$:.unshift File.expand_path('../../../', __FILE__)

require 'rails_helper'

describe RSpec::Scaffold, type: :rails_integration do
  describe '#helper_file' do
    it 'returns "rails_helper"' do
      expect(described_class.helper_file).to eq 'rails_helper'
    end

    context 'when RSpec is version 3.0 or less' do
      it 'returns "spec_helper"' do
        expect(RSpec::Core::Version::STRING).to receive(:to_s).and_return('2.5.0')
        expect(described_class.helper_file).to eq 'spec_helper'
      end
    end
  end

end

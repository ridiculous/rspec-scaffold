# rspec spec/lib/rspec/scaffold/text_generator_spec.rb
describe RSpec::Scaffold::TextGenerator do
  klass = RSpec::Scaffold::TextGenerator

  describe '.perform' do
    context "when given relatively simple ruby code as text" do
      let(:text) { File.read(FIXTURE_ROOT.join('report.rb')) }

      it 'should return the spec scaffold for the given ruby code as an array of lines' do
        expect(klass.new(text).perform.join("\n")).to eq report_rb_test_scaffold
      end
    end

  end
end

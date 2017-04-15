# rspec spec/lib/rspec/scaffold/generator_spec.rb
describe RSpec::Scaffold::Generator do
  let(:file) { FIXTURE_ROOT.join('report.rb') }
  let(:ryan) { Ryan.new(file) }

  describe '.perform' do
    subject { described_class.new(ryan).perform.join("\n") }

    context "when given standart test code" do
      it 'returns the spec for the given file as an array of lines' do
        expect(subject).to eq report_rb_test_scaffold
      end
    end

    context "when given simple code as string" do
      let(:file) { FIXTURE_ROOT.join('report.rb') }
      let(:text) { File.read(file) }
      let(:file_ryan) { Ryan.new(file) }
      let(:text_ryan) { Ryan.new(text) }

      it "should return a correct scaffold" do
        expect(described_class.new(text_ryan).perform.join("\n")).to eq report_rb_test_scaffold
      end

      it "should return the same correct scaffold that would be generated for a file argument" do
        expect(described_class.new(file_ryan).perform).to eq described_class.new(text_ryan).perform
      end
    end

    context 'when given a file with a long if/elsif/else' do
      let(:file) { FIXTURE_ROOT.join('extensions.rb') }

      it 'returns an array of lines for the file' do
        expect(subject).to eq extensions_rb_test_scaffold
      end
    end

    context 'when given a file with a nested condition in a block' do
      let(:file) { FIXTURE_ROOT.join('controllers/application_controller.rb') }

      it 'rejects multiline statements to protect the client from our shortcomings' do
        expect(subject).to eq application_controller_rb_test_scaffold
      end
    end

    #== edge ==
    context "when the parser encounters an error" do
      it "should reraie it as a specific parse error" do
        expect{ described_class.new(Ryan.new(%Q|class Fancy; ((; end|)).perform }.to raise_error(Racc::ParseError, %r'parse error on value')
      end
    end

  end

  describe 'Parsing functionality (Ryan)' do
    describe '#const' do
      it 'returns the Ruby constant defined in the given file' do
        expect(ryan.name).to eq 'Report'
      end

      context 'when the constant is namespaced' do
        let(:file) { FIXTURE_ROOT.join('mixins/helpers/date_helper.rb') }

        it 'returns the correct constant' do
          expect(ryan.name).to eq 'Mixins::Helpers::DateHelper'
        end
      end
    end

    describe '#name' do
      it 'returns the name of the Ruby class in the given file' do
        expect(ryan.name).to eq 'Report'
      end
    end

    describe '#funcs' do
      it 'returns an array with all the methods defined in the target file' do
        expect(ryan.funcs).to be_a Array
        expect(ryan.funcs.length).to eq 12
        expect(ryan.funcs.select(&:class?).length).to eq 4
        expect(ryan.funcs.reject(&:class?).length).to eq 8
        expect(ryan.funcs.select(&:private?).length).to eq 2
        expect(ryan.funcs.first.name).to eq :enqueue
        expect(ryan.funcs.first.conditions.map(&:full_statement)).to eq ["return unless verification_code"]
      end
    end

    describe '#initialization_args' do
      it 'returns a list of args to initialize the class' do
        expect(ryan.initialization_args).to eq [:message]
      end

      context 'when the subject takes multiple args' do
        let(:file) { FIXTURE_ROOT.join('multiple_args.rb') }

        it 'returns all the args' do
          expect(ryan.initialization_args).to eq [:name, :age, :"*args"]
        end
      end

      context 'when the subject takes no args' do
        let(:file) { FIXTURE_ROOT.join('controllers/reservations_controller.rb') }

        it 'returns an empty array' do
          expect(ryan.initialization_args).to eq []
        end
      end
    end

    describe '#class?' do
      context 'when the subject is a class' do
        it 'returns true' do
          expect(ryan).to be_class
        end
      end

      context 'when the subject is a module' do
        let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

        it 'returns false' do
          expect(ryan).to_not be_class
        end
      end
    end

    describe '#module?' do
      context 'when the subject is a module' do
        let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

        it 'returns true' do
          expect(ryan).to be_module
        end
      end

      context 'when the subject is a class' do
        it 'returns false' do
          expect(ryan).to_not be_module
        end
      end

    end

  end

end

# rspec spec/lib/rspec/scaffold/generator_spec.rb
describe RSpec::Scaffold::Generator do
  let(:file) { FIXTURE_ROOT.join('report.rb') }

  subject { described_class.new(file) }

  describe '.perform' do
    context "when given a relatively simple file" do
      it 'should return the spec for the given file as an array of lines' do
        expect(subject.perform.join("\n")).to eq report_rb_test_scaffold
      end
    end

    context 'when given a file with a long if/elsif/else' do
      let(:file) { FIXTURE_ROOT.join('extensions.rb') }

      it 'returns an array of lines for the file' do
        expect(subject.perform.join("\n")).to eq extensions_rb_test_scaffold
      end
    end

    context 'when given a file with a nested condition in a block' do
      let(:file) { FIXTURE_ROOT.join('controllers/application_controller.rb') }

      it 'rejects multiline statements to protect the client from our shortcomings' do
        expect(subject.perform.join("\n")).to eq application_controller_rb_test_scaffold
      end
    end

    context "when given a file that has no class definition, just methods" do
      let(:file) { FIXTURE_ROOT.join('no_class.rb') }

      xit "should " do
        expect(0).to eq 1
      end
    end

  end

  describe '#const' do
    it 'returns the Ruby constant defined in the given file' do
      expect(subject.const).to eq Report
    end

    context 'when the constant is namespaced' do
      let(:file) { FIXTURE_ROOT.join('mixins/helpers/date_helper.rb') }

      it 'returns the correct constant' do
        expect(subject.const).to eq Mixins::Helpers::DateHelper
      end
    end
  end

  describe '#name' do
    it 'returns the name of the Ruby class in the given file' do
      expect(subject.name).to eq 'Report'
    end
  end

  describe '#funcs' do
    it 'returns an array with all the methods defined in the target file' do
      expect(subject.funcs).to be_a Array
      expect(subject.funcs.length).to eq 12
      expect(subject.funcs.select(&:class?).length).to eq 4
      expect(subject.funcs.reject(&:class?).length).to eq 8
      expect(subject.funcs.select(&:private?).length).to eq 2
      expect(subject.funcs.first.name).to eq :enqueue
      expect(subject.funcs.first.conditions.map(&:full_statement)).to eq ["return unless verification_code"]
    end
  end

  describe '#initialization_args' do
    it 'returns a list of args to initialize the class' do
      expect(subject.initialization_args).to eq [:message]
    end

    context 'when the subject takes multiple args' do
      let(:file) { FIXTURE_ROOT.join('multiple_args.rb') }

      it 'returns all the args' do
        expect(subject.initialization_args).to eq [:name, :age, :"*args"]
      end
    end

    context 'when the subject takes no args' do
      let(:file) { FIXTURE_ROOT.join('controllers/reservations_controller.rb') }

      it 'returns an empty array' do
        expect(subject.initialization_args).to eq []
      end
    end
  end

  describe '#class?' do
    context 'when the subject is a class' do
      it 'returns true' do
        expect(subject).to be_class
      end
    end

    context 'when the subject is a module' do
      let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

      it 'returns false' do
        expect(subject).to_not be_class
      end
    end
  end

  describe '#module?' do
    context 'when the subject is a module' do
      let(:file) { FIXTURE_ROOT.join('mixins/models.rb') }

      it 'returns true' do
        expect(subject).to be_module
      end
    end

    context 'when the subject is a class' do
      it 'returns false' do
        expect(subject).to_not be_module
      end
    end
  end

end

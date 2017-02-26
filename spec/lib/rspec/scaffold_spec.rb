# rspec spec/lib/rspec/scaffold_spec.rb
describe RSpec::Scaffold do
  klass = RSpec::Scaffold

  describe ".helper_file" do
    # class ::Rails; end # a simple way to have Rails defined

    it "should return 'rails_helper' if Rails version is 3 or above" do
      allow(RSpec::Core::Version::STRING).to receive(:to_s).and_return('3')

      expect(klass.helper_file).to eq 'rails_helper'
    end

    it "should return 'spec_helper' if Rails not used or the version is below 3" do
      allow(RSpec::Core::Version::STRING).to receive(:to_s).and_return('2')

      expect(klass.helper_file).to eq 'spec_helper'
    end
  end

  describe ".testify_file(filepath, mode=:to_file)" do
    let(:path) { klass.root + "spec/fixtures/classes/ability.rb" }

    context "when passed a single file and :to_text mode" do
      it "should puts about action taken and return the scaffold as text" do
        expect(0).to eq 1
      end
    end


    # it "should trigger RSpec::Scaffold::Runner#perform and return test scaffold string" do
    #   exp = ability_class_test_scaffold
    #   expect(klass.testify(path)).to eq exp
    # end
    #
    # it "should return whatever Runner's #perform method returns" do
    #   allow_any_instance_of(RSpec::Scaffold::Runner).to receive(:perform).and_return("test scaffold lines")
    #
    #   expect(klass.testify(path)).to eq "test scaffold lines"
    # end
  end

  describe ".testify_text(text)" do
    it "should return trigger Generator.new(text).perform and return the scaffold string" do
      expect_any_instance_of(RSpec::Scaffold::Generator).to receive(:perform).and_return("test scaffold string")

      expect(described_class.testify_text("test input")).to eq "test scaffold string"
    end
  end

  describe ".root" do
    it "should return the path to gem's root dir" do
      expect(klass.root.to_s[%r'/rspec-scaffold\z']).to eq "/rspec-scaffold"
    end
  end

end

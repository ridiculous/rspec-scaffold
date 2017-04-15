# rspec spec/lib/rspec/scaffold_spec.rb
describe RSpec::Scaffold do
  klass = RSpec::Scaffold

  describe ".helper_file" do
    it "should return 'rails_helper' if Rails version is 3 or above" do
      allow(RSpec::Core::Version::STRING).to receive(:to_s).and_return('3')
      allow(Object).to receive(:const_defined?).with("Rails").and_return(true)

      expect(klass.helper_file).to eq 'rails_helper'
    end

    it "should return 'spec_helper' if Rails not used or the version is below 3" do
      allow(RSpec::Core::Version::STRING).to receive(:to_s).and_return('2')

      expect(klass.helper_file).to eq 'spec_helper'
    end
  end

  describe ".testify_file(filepath, mode=:to_file)" do
    let(:path) { FIXTURE_ROOT.join('models/activity_feature.rb').to_s }
    let(:same_dir_spec_path) { path.to_s.gsub(%r'\.rb\z', '_spec.rb') }
    let(:custom_output_path) { RSpec::Scaffold.root.join("spec/fixtures/spec/models/activity_feature_spec.rb").to_s }

    context "when passed :to_text mode" do
      it "should return the scaffold as a String object" do
        expect(described_class.testify_file(path)).to eq models_activity_feature_rb_test_scaffold
      end
    end

    context "when passed :to_file mode with no output path" do
      it "should puts about where test scaffold was saved to, output to a file (in the same directory as original) and return the path" do
        FakeFS.with_fresh do
          # this setup makes sure output is only written within this test
          spec_dir = File.expand_path('../../..', __FILE__)
          FakeFS::FileSystem.clone(spec_dir)

          expect(STDOUT).to receive(:puts).ordered.with(%r'/rspec-scaffold/spec/fixtures/models/activity_feature_spec.rb')

          expect{@path = described_class.testify_file(path, :to_file)}.
          to change{Pathname.new("#{path.to_s.gsub(%r'\.rb\z', '_spec.rb')}").exist?}.from(false).to(true)

          expect( @path.to_s ).to match(%r'/rspec-scaffold/spec/fixtures/models/activity_feature_spec.rb\z')
        end
      end

    end

    context "when passed :to_file mode with an output path" do
      it "should puts about where test scaffold was saved to and output to the specified file" do
        FakeFS.with_fresh do
          # this setup makes sure output is only written within this test
          spec_dir = File.expand_path('../../..', __FILE__)
          FakeFS::FileSystem.clone(spec_dir)

          expect(STDOUT).to receive(:puts).ordered.with(%r'/rspec-scaffold/spec/fixtures/spec/models/activity_feature_spec.rb')

          expect{@path = described_class.testify_file(path, :to_file, custom_output_path)}.
            # make custom file
            to change{Pathname.new(custom_output_path).exist?}.from(false).to(true).
            # but do not make the file that would be made if no custom path is given
            and not_change{Pathname.new(same_dir_spec_path).exist?}

          expect( @path.to_s ).to match(%r'#{custom_output_path}\z')
        end
      end
    end

    context "when an outputabble file already exists" do
      it "should puts about file being present and getting skipped and not change the contents" do
        FakeFS.with_fresh do
          # this setup makes sure output is only written within this test
          spec_dir = File.expand_path('../../..', __FILE__)
          FakeFS::FileSystem.clone(spec_dir)

          # make sure the file already exists
          File.open(same_dir_spec_path, 'w') {|f| f << "Test contents" }

          expect(STDOUT).to receive(:puts).ordered.with(%r'/rspec-scaffold/spec/fixtures/models/activity_feature_spec.rb - already exists')

          # second, actual repeat
          expect{described_class.testify_file(path, :to_file)}.
            to_not change{File.read(same_dir_spec_path)}
        end
      end
    end

  end

  describe ".testify_text(text)" do
    let(:file) { FIXTURE_ROOT.join('models/activity_feature.rb') }
    let(:text) { File.read(file) }

    subject { described_class.testify_text(text) }

    it "should trigger Generator.new(text).perform and return the scaffold string" do
      expect(subject).to eq models_activity_feature_rb_test_scaffold
    end
  end

  describe ".root" do
    it "should return the path to gem's root dir" do
      expect(klass.root.to_s[%r'/rspec-scaffold\z']).to eq "/rspec-scaffold"
    end
  end

end

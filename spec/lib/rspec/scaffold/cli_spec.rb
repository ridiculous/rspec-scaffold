# rspec spec/lib/rspec/scaffold/cli_spec.rb
describe RSpec::Scaffold::Cli do
  let(:boot_path) { RSpec::Scaffold.root.join("spec/dummy") }
  let(:cli) { described_class.new(boot_path) }
  subject { cli.start }

  before :each do
    FakeFS.activate!
    FakeFS::FileSystem.clone(RSpec::Scaffold.root.join("spec"))
  end

  after :each do
    FakeFS.deactivate!
  end

  describe ".start(boot_path)" do
    before :each do
      allow(described_class).to receive(:command_line_arguments).and_return([])
    end

    context "when ran with no command line arguments or options" do

      it "should output help text and do nothing" do
        expect(STDOUT).to receive(:puts).ordered.with(%r'Usage:')
        expect(subject).to eq true
      end
    end

    context "when ran with -h or --help options" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["--help"])
      end

      it "should output help text and do nothing" do
        expect(STDOUT).to receive(:puts).ordered.with(%r'Usage:')
        subject
      end
    end

    context "when passed path is not a file or dir in project root" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["--help"])
      end

      it "should output a 'not found' warning text and do nothing" do
        expect(0).to eq 1
      end
    end

    context "when ran with no options on a single relative file" do
      let(:path_base) { "models/concerns/user/auth.rb" }
      let(:input_path) { "app/#{path_base}" }
      let(:expected_spec_path) { RSpec::Scaffold.root.join("spec/dummy/spec/#{path_base}").to_s.gsub(%r'\.rb\z', '_spec.rb') }

      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return([input_path])
      end

      it "should output text about creating test scaffold and make the file" do
        expect(STDOUT).to receive(:puts).ordered.with("a")#with(%r'Usage:')

        expect{subject}.
          to change{Pathname.new(expected_spec_path).exist?}.from(false).to(true)
      end
    end

    context "when ran with no options on a relative directory" do
      it "should not prompt the user for approval for recursive scaffolding if there are 4 or less files" do
        allow(cli).to receive(:many_processable_file_danger?).and_return(false)
        expect(0).to eq 1
      end

      it "should prompt the user for approval for recursive scaffolding if there are 5 or more files " do
        allow(cli).to receive(:many_processable_file_danger?).and_return(true)
        expect(0).to eq 1
      end

      it "should create test scaffolds recursively after accepting approval or if -y flag is given" do
        allow(cli).to receive(:many_processable_file_danger?).and_return(true)
        # allow(STDIN).to receive(:gets) { 'joe' }
        expect(0).to eq 1
      end
    end

    context "when ran with -t or --text option on a single relative file" do
      it "should output the test scaffold to console" do
        expect(0).to eq 1
      end
    end

    context "when ran with -t or --text option on a relative directory" do
      it "should not ask for verification and proceed to spew out test scaffolds for all files" do
        expect(0).to eq 1
      end
    end

    context "when ran with no options on an absolute file" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["/absolute/path/ruby.rb"])
      end

      it "should output text about this feature not being available (yet)" do
        expect(0).to eq 1
      end
    end

    context "when ran with no options on an absolute directory" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["/absolute/path/"])
      end

      it "should output text about this feature not being available (yet)" do
        expect(0).to eq 1
      end
    end

    #== edge ==



  end

end

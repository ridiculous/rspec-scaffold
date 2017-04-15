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
    FakeFS::FileSystem.clear
  end

  describe ".command_line_arguments" do
    it "should serve as a mockable proxy for accesing the ARGV array" do
      expect(described_class.command_line_arguments).to be_an Array
    end
  end

  describe "#start(boot_path)" do
    before :each do
      allow(described_class).to receive(:command_line_arguments).and_return([])
    end

    context "when ran with no command line arguments or options" do

      it "should output help text and do nothing" do
        expect(STDOUT).to receive(:puts).ordered.with(%r'Usage:')
        expect{subject}.to raise_error(SystemExit)
      end
    end

    context "when ran with -h or --help options" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["--help"])
      end

      it "should output help text and do nothing" do
        expect(STDOUT).to receive(:puts).ordered.with(%r'Usage:')
        expect{subject}.to raise_error(SystemExit)
      end
    end

    context "when passed path is not a file nor dir in project root" do
      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["random/file.rb"])
      end

      it "should output a 'not found' warning text and do nothing" do
        expect(STDOUT).to receive(:puts).ordered.with(%r'Could not find')
        expect{subject}.to raise_error(SystemExit)
      end
    end

    context "when running single file scaffolding" do
      let(:path_base) { "models/concerns/user/auth.rb" }
      let(:input_path) { "app/#{path_base}" }
      let(:expected_spec_path) { RSpec::Scaffold.root.join("spec/dummy/spec/#{path_base}").to_s.gsub(%r'\.rb\z', '_spec.rb') }

      context "when ran with no options" do
        before :each do
          allow(described_class).to receive(:command_line_arguments).and_return([input_path])
        end

        it "should output text about creating test scaffold and make the file" do
          expect(STDOUT).to receive(:puts).ordered.with(%r'\+.*?rspec-scaffold/spec/dummy/spec/models/concerns/user/auth_spec.rb')

          expect{@return = subject}.
            to change{Pathname.new(expected_spec_path).exist?}.from(false).to(true)

          expect( @return ).to eq true
        end

      end

      context "when ran with -t or --text option" do
        before :each do
          allow(described_class).to receive(:command_line_arguments).and_return(["-t", input_path])
        end

        it "should output the test scaffold to console, not filesystem" do
          allow(STDOUT).to receive(:puts).and_return(nil)
          expect(STDOUT).to receive(:puts).with(%r'\A#== .*?rspec-scaffold/spec/dummy/app/models/concerns/user/auth.rb ==').once
          expect(STDOUT).to receive(:puts).with(%r'subject \{ described_class\.new').once

          expect{subject}.
            to not_change{Pathname.new(expected_spec_path).exist?}
        end
      end

    end

    context "when calling scaffolding on relative directory" do
      let(:input_path) { "app" }

      # the run should make three test files and fail one because SyntaxError
      let(:expected_spec1) { RSpec::Scaffold.root.join("spec/dummy/spec/models/user_spec.rb") }
      let(:expected_spec2) { RSpec::Scaffold.root.join("spec/dummy/spec/models/concerns/user/auth_spec.rb") }
      let(:expected_spec3) { RSpec::Scaffold.root.join("spec/dummy/spec/lib/some_service_class_spec.rb") }
      let(:expected_spec4) { RSpec::Scaffold.root.join("spec/dummy/spec/models/bug_spec.rb") }

      context "when ran with no options on a relative directory" do
        before :each do
          allow(described_class).to receive(:command_line_arguments).and_return([input_path])
        end

        it "should not prompt the user for approval for recursive scaffolding if there are 4 or less files and recursively make scaffolds" do
          allow(cli).to receive(:many_processable_file_danger?).and_return(false)
          allow(STDOUT).to receive(:puts)

          expect{subject}.
            to change{Pathname.new(expected_spec1).exist?}.from(false).to(true).
            and change{Pathname.new(expected_spec2).exist?}.from(false).to(true).
            and change{Pathname.new(expected_spec3).exist?}.from(false).to(true).
            and not_change{Pathname.new(expected_spec4).exist?}
        end

        it "should prompt the user for approval for recursive scaffolding if there are 5 or more files and abort if answered non-yes" do
          allow(cli).to receive(:many_processable_file_danger?).and_return(true)
          allow(STDIN).to receive(:gets).and_return("n")

          expect{subject}.to raise_error(SystemExit)
        end

        it "should confirm the acceptance (and create test scaffolds recursively) if entered Y or -y flag is given" do
          allow(cli).to receive(:many_processable_file_danger?).and_return(true)
          allow(STDIN).to receive(:gets).and_return("y")

          expect( STDOUT ).to receive(:puts).ordered.with("done")
          expect( STDOUT ).to receive(:puts).ordered.with(%r'Many files are about to be processed')
          expect( STDOUT ).to receive(:puts).ordered.with(%r' Proceeding with scaffold build!')
          expect( STDOUT ).to receive(:puts).with(anything).ordered.at_least(5).times

          expect{subject}.to_not raise_error
        end
      end

      context "when ran with -t or --text option on a relative directory" do
        before :each do
          allow(described_class).to receive(:command_line_arguments).and_return(["--text", input_path])
        end

        it "should not ask for verification and proceed to spew out test scaffolds for all files" do
          allow(cli).to receive(:many_processable_file_danger?).and_return(true)
          allow(STDIN).to receive(:gets).and_return("n") # this will not matter

          allow(STDOUT).to receive(:puts)
          allow(RSpec::Scaffold).to receive(:testify_file).and_return(nil)
          expect(RSpec::Scaffold).to receive(:testify_file).with(anything, :to_text).exactly(5).times

          expect{subject}.to_not raise_error
        end
      end

    end

    context "when ran with no options on an absolute file" do
      let(:input_path) { "/app.rb" }

      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["/absolute/path/ruby.rb"])
      end

      it "should abort with text about this feature not being available (yet)" do
        expect( STDOUT ).to receive(:puts).with(%r'\AAbsolute path argument')

        expect{subject}.to raise_error(SystemExit)
      end
    end

    context "when ran with no options on an absolute directory" do
      let(:input_path) { "/app" }

      before :each do
        allow(described_class).to receive(:command_line_arguments).and_return(["/absolute/path/"])
      end

      it "should output text about this feature not being available (yet)" do
        expect( STDOUT ).to receive(:puts).with(%r'\AAbsolute path argument')

        expect{subject}.to raise_error(SystemExit)
      end
    end

    #== edge ==



  end

end

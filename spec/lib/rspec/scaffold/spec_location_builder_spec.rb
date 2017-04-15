# rspec spec/lib/rspec/scaffold/spec_location_builder_spec.rb
describe RSpec::Scaffold::SpecLocationBuilder do
  let(:project_root) { RSpec::Scaffold.root.join("spec/dummy/") }
  let(:file_path) { "app/models/user.rb" }
  let(:builder) { described_class.new(project_root, file_path) }

  describe "#spec_location" do
    subject { builder.spec_location.to_s }

    context "when initialized with a model path" do
      it { is_expected.to eq project_root.join("spec/models/user_spec.rb").to_s }
    end

    context "when initialized with a concern path " do
      let(:file_path) { "app/models/concerns/user/auth.rb" }

      it { is_expected.to eq project_root.join("spec/models/concerns/user/auth_spec.rb").to_s }
    end

    context "when initialized with a non-app dir (like '/lib') path" do
      let(:file_path) { "lib/external/google.rb" }

      it { is_expected.to eq project_root.join("spec/lib/external/google_spec.rb").to_s }
    end

    context "when initialized with an absolute :file_path" do
      let(:file_path) { project_root.join("lib/external/google.rb") }

      it { is_expected.to eq project_root.join("spec/lib/external/google_spec.rb").to_s }
    end

  end

end

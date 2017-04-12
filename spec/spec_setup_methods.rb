class String
  def unindent
    return gsub(%r'^#{self[/\A\s*/]}', '')
  end
end

#== Raw ruby ==

# def method_name
#
# end

#== Expectations ==

def ability_class_test_scaffold
  string = <<-ENDBAR.unindent
    # rspec spec/models/ability_spec.rb
    describe Ability do
      let(:user) {}

      subject { described_class.new user }

      describe "#initialize" do
        context "when user.admin?" do
          before {}
        end

        context "unless user.admin?" do
          before {}
        end
      end
    end
  ENDBAR

  return string
end

def example_scaffold_method
  string = <<-ENDBAR.unindent

  ENDBAR

  return string
end

def report_rb_test_scaffold
  string = <<-ENDBAR.unindent
    # spring rspec
    describe Report do
      let(:message) {}

      subject { described_class.new message }

      describe ".enqueue" do
        context "unless verification_code" do
          before {}

          it "returns nil" do
          end
        end

        context "when verification_code" do
          before {}
        end
      end

      describe ".process" do
      end

      describe ".replace" do
      end

      describe "#initialize" do
        it "assigns @message" do
        end
      end

      describe "#map_args" do
        context "unless val" do
          before {}

          it "returns list" do
          end
        end

        context "when val" do
          before {}
        end
      end

      describe "#go" do
        context "when (@duder == -1)" do
          before {}

          it "assigns @go = :ok" do
          end
        end

        context "not (@duder == -1)" do
          before {}
        end
      end

      describe "#call" do
        it "assigns @duder" do
        end

        context "unless (message[:verification_code_id] or message['verification_code_id'])" do
          before {}

          it "returns []" do
          end
        end

        context "when (message[:verification_code_id] or message['verification_code_id'])" do
          before {}
        end
        context "when (1 == 2)" do
          before {}

          it "returns 0" do
          end
        end

        context "not (1 == 2)" do
          before {}

          it "returns -1" do
          end
        end
        context "when report.save" do
          before {}

          it "returns report.perform" do
          end

          context "when user.wants_mail?" do
            before {}

            it "returns UserMailer.spam(user).deliver_now" do
            end
          end

          context "not user.wants_mail?" do
            before {}
          end
        end

        context "when report.save!" do
          before {}

          it "returns report.force_perform" do
          end
        end
        context "not report.save!" do
          before {}

          it "returns report.failure" do
          end
        end
      end

      describe "#report" do
        it "assigns @report" do
        end
      end

      describe "#verification_code" do
        it "assigns @verification_code" do
        end
      end

      describe ".find" do
      end

    end
  ENDBAR

  return string
end

def extensions_rb_test_scaffold
  string = <<-ENDBAR.unindent
    # spring rspec
    describe Extensions do
      subject { Class.new { include Extensions }.new }

      describe "#load_and_authorize_item!" do
        context "when coupon.nil?" do
          before {}

          it "returns fail(Error, 'Couldn't find the coupon')" do
          end

          context "when coupon.expired?" do
            before {}

            it "returns fail(Error, 'Coupon has expired')" do
            end
          end

          context "when coupon.inactive?" do
            before {}

            it "returns fail(Error, 'Coupon is not activated')" do
            end
          end
          context "not coupon.inactive?" do
            before {}

            it "assigns @item = coupon" do
            end
          end
          context "when coupon.inactive?" do
            before {}

            it "returns fail(Error, 'Coupon is not activated')" do
            end
          end

          context "not coupon.inactive?" do
            before {}

            it "assigns @item = coupon" do
            end
          end
        end

        context "when coupon.cannot_use?" do
          before {}

          it "returns fail(Error, 'Coupon has been used up')" do
          end
        end
      end

      describe "#call" do
        it "assigns @called" do
        end
      end

      describe "#go" do
        it "assigns @go" do
        end
      end

      describe "#index" do
        it "assigns @title" do
        end
        it "assigns @finder" do
        end
        it "assigns @infections" do
        end
        it "assigns @notification" do
        end
      end

    end
  ENDBAR

  return string
end

def application_controller_rb_test_scaffold
  string = <<-ENDBAR.unindent
    # spring rspec
    describe ApplicationController do

      subject { described_class.new  }

      describe ".before_filter" do
      end

      describe "#current_user" do
        it "assigns @current_user" do
        end

        context "when defined? @current_user" do
          before {}

          it "returns @current_user" do
          end

          context "when cookies[:auth_token]" do
            before {}

            it "returns User.find_by!(:auth_token => cookies[:auth_token])" do
            end
          end

          context "not cookies[:auth_token]" do
            before {}
          end
        end

        context "not defined? @current_user" do
          before {}
        end
      end

    end
  ENDBAR

  return string
end

def models_activity_feature_rb_test_scaffold
  string = <<-ENDBAR.unindent
    # spring rspec
    describe ActivityFeature do

      subject { described_class.new  }

      describe ".localized_fields" do
      end

      describe "#image" do
      end

    end
  ENDBAR

  return string
end

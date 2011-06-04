require 'spec_helper'
require 'user'

class Should
  include ValidAttribute::Method
end

describe 'ValidAttribute' do

  before do
    @should = Should.new
    @user   = User.new
  end

  describe 'matcher result' do
    context 'data is valid' do
      before do
        @user.stubs(:valid?).returns(true)
        @user.stubs(:errors).returns(mock() { expects(:include?).twice.with(:name).returns(false) })
        @matcher = @should.have_valid(:name).when('abc', 123)
      end

      it 'matches? returns true' do
        @matcher.matches?(@user).should be_true
      end

      it 'does_not_match? returns false' do
        @matcher.does_not_match?(@user).should be_false
      end

      describe 'messages' do
        it '#negative_failue_message' do
          @matcher.matches?(@user)
          @matcher.negative_failure_message.should == " expected User#name to not accept the values: \"abc\", 123"
        end
      end
    end

    context 'data is invalid' do
      before do
        @user.stubs(:valid?).returns(false)
        @user.stubs(:errors).returns(mock() { expects(:include?).twice.with(:name).returns(true) })
        @matcher = @should.have_valid(:name).when(:abc, nil)
      end

      it 'matches? returns false' do
        @matcher.matches?(@user).should be_false
      end

      it 'does_not_match? returns true' do
        @matcher.does_not_match?(@user).should be_true
      end

      describe 'messages' do
        it '#failue_message' do
          @matcher.matches?(@user)
          @matcher.failure_message.should == " expected User#name to accept the values: :abc, nil"
        end
      end
    end

    context 'data is valid then invalid' do
      before do
        @user.stubs(:valid?).returns(true).then.returns(false)
        @user.stubs(:errors).returns(mock() { expects(:include?).at_most(2).with(:name).returns(false).then.returns(true) })
        @matcher = @should.have_valid(:name).when('abc', 123)
      end

      it 'matches? returns false' do
        @matcher.matches?(@user).should be_false
      end

      it 'does_not_match? returns false' do
        @matcher.does_not_match?(@user).should be_false
      end

      describe 'messages' do
        it '#failure_message' do
          @matcher.matches?(@user)
          @matcher.failure_message.should == " expected User#name to accept the value: 123"
        end

        it '#negative_failure_message' do
          @matcher.matches?(@user)
          @matcher.negative_failure_message.should == " expected User#name to not accept the value: \"abc\""
        end

        it '#description' do
          @matcher.description.should == "be valid when: \"abc\", 123"
        end
      end
    end
  end

  it 'requires .when to always be used' do
    matcher = @should.have_valid(:name)
    expect do
      matcher.matches?(@user)
    end.to raise_error ValidAttribute::NoValues, "you need to set the values with .when on the matcher. Example: have_valid(:name).when('Brian')"
  end

end

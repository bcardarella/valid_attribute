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
        @user.stubs(:errors).returns({})
        @matcher = @should.have_valid(:name).when('abc', 123)
      end

      it 'matches? returns true' do
        @matcher.matches?(@user).should be_true
      end

      it 'does_not_match? returns false' do
        @matcher.does_not_match?(@user).should be_false
      end

      describe 'messages' do
        it '#negative_failure_message' do
          @matcher.matches?(@user)
          @matcher.negative_failure_message.should == " expected User#name to reject the values: \"abc\", 123"
        end
      end
    end

    context 'data is invalid' do
      before do
        @user.stubs(:valid?).returns(false)
        @user.stubs(:errors).returns({:name => ["can't be blank"]})
        @matcher = @should.have_valid(:name).when(:abc, nil)
      end

      it 'matches? returns false' do
        @matcher.matches?(@user).should be_false
      end

      it 'does_not_match? returns true' do
        @matcher.does_not_match?(@user).should be_true
      end

      describe 'messages' do
        it '#failure_message' do
          @matcher.matches?(@user)
          @matcher.failure_message.should == " expected User#name to accept the values: :abc, nil"
        end
      end
    end

    context 'data is valid then invalid' do
      before do
        @user.stubs(:valid?).returns(true).then.returns(false)
        @user.stubs(:errors).returns({}).then.returns({:name => ["can't be blank"]})
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
          @matcher.negative_failure_message.should == " expected User#name to reject the value: \"abc\""
        end

        it '#description' do
          @matcher.description.should == "be valid when name is: \"abc\", 123"
        end
      end
    end

    context 'no values are specified with .when' do
      context 'data is not set' do
        before do
          @user.stubs(:valid?).returns(true)
          @user.stubs(:name).returns(nil)
          @matcher = @should.have_valid(:name)
        end

        subject do
          @matcher.matches?(@user)
          @matcher
        end

        its(:description) { should eq('be valid when name is: nil') }
      end

      context 'data is valid' do
        before do
          @user.stubs(:valid?).returns(true)
          @user.stubs(:name).returns(:abc)
          @matcher = @should.have_valid(:name)
        end

        it 'matches? returns true' do
          @matcher.matches?(@user).should be_true
        end

        it 'does_not_match? returns false' do
          @matcher.does_not_match?(@user).should be_false
        end

        describe 'messages' do
          it '#negative_failure_message' do
            @matcher.matches?(@user)
            @matcher.negative_failure_message.should == " expected User#name to reject the value: :abc"
          end
        end
      end

      context 'data is invalid' do
        before do
          @user.stubs(:valid?).returns(false)
          @user.stubs(:errors).returns({:name => ["can't be a symbol"]})
          @user.stubs(:name).returns(:abc)
          @matcher = @should.have_valid(:name)
        end

        it 'matches? returns false' do
          @matcher.matches?(@user).should be_false
        end

        it 'does_not_match? returns true' do
          @matcher.does_not_match?(@user).should be_true
        end

        describe 'messages' do
          it '#failure_message' do
            @matcher.matches?(@user)
            @matcher.failure_message.should == " expected User#name to accept the value: :abc"
          end
        end
      end
    end

    describe 'cloning' do
      before do
        @matcher = @should.have_valid(:name)
      end

      context 'when no cloning' do
        it 'returns false' do
          @matcher.clone?.should be_false
        end
      end
      context 'when cloned' do
        before do
          @matcher.clone
        end
        it 'returns true' do
          @matcher.clone?.should be_true
        end
      end
    end
  end

end

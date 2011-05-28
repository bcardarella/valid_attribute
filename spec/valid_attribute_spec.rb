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

  describe 'valid data' do
    before do
      @user.stubs(:valid?).returns(true)
    end

    it 'passes with values' do
      matcher = @should.have_valid(:name).when('Brian', 'Stephanie')
      matcher.matches?(@user).should be_true
    end
  end

  describe 'data is first invalid then invalid' do
    before do
      @user.stubs(:valid?).returns(false).then.returns(true).then.returns(false).then.returns(true)
      @user.stubs(:errors).returns({:name => []}).then.returns({}).then.returns({:name => []}).then.returns({})
      @matcher        = @should.have_valid(:name).when('abc', 123)
      @matches        = @matcher.matches?(@user)
      @does_not_match = @matcher.does_not_match?(@user)
    end

    it 'matches? returns false' do
      @matches.should be_false
    end

    it 'does_not_match? returns false' do
      @does_not_match.should be_false
    end

    it 'has a failure message of the failed values' do
      @matcher.failure_message.should == " expected User#name to accept the value: 'abc'"
    end

    it 'has a negative failure message of the passed values' do
      @matcher.negative_failure_message.should == " expected User#name to not accept the value: 123"
    end

    it 'has a description' do
      @matcher.description.should == "be valid when: 'abc', 123"
    end
  end

  describe 'data is first invalid then valid then invalid then valid' do
    before do
      @user.stubs(:valid?).returns(false).then.returns(true).then.returns(false).then.returns(false).then.returns(true).then.returns(false)
      @user.stubs(:errors).returns({:name => []}).then.returns({}).then.returns({:name => []}).then.returns({}).then.returns({:name => []}).then.returns({}).then.returns({:name => []}).then.returns({})
      @matcher        = @should.have_valid(:name).when('abc', 123, 456, 'def')
      @matches        = @matcher.matches?(@user)
      @does_not_match = @matcher.does_not_match?(@user)
    end

    it 'matches? returns false' do
      @matches.should be_false
    end

    it 'does_not_match? returns true' do
      @does_not_match.should be_false
    end

    it 'has a failure message of the failed values' do
      @matcher.failure_message.should == " expected User#name to accept the values: 'abc', 456"
    end

    it 'has a negative failure message of the passed values' do
      @matcher.negative_failure_message.should == " expected User#name to not accept the values: 123, 'def'"
    end

    it 'has a description' do
      @matcher.description.should == "be valid when: 'abc', 123, 456, 'def'"
    end
  end

  it 'requires .when to always be used' do
    matcher = @should.have_valid(:name)
    expect do
      matcher.matches?(@user)
    end.to raise_error ValidAttribute::NoValues, "you need to set the values with .when on the matcher (ex. it { should have_valid(:name).when('Brian') })"
  end

end

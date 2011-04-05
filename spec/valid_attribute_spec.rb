require 'spec_helper'

class Should
  include ValidAttribute
end

class User
  attr_accessor :name

  def errors
    @error ||= {}
  end

  def self.model_name
    'User'
  end
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

    it 'passes with no value set' do
      matcher = @should.have_valid(:name).with(nil)
      matcher.matches?(@user).should be_true
    end

    it 'passes with values set' do
      matcher = @should.have_valid(:name).with('Brian', 'Stephanie')
      matcher.matches?(@user).should be_true
    end
  end

  describe 'invalid data' do
    before do
      @user.stubs(:valid?).returns(false)
      @user.errors[:name] = ['is not valid']
    end

    it 'returns false when no message passed' do
      matcher = @should.have_valid(:name).with(nil)
      matcher.matches?(@user).should be_false
    end

    it 'returns true when wrong message is passed' do
      matcher = @should.have_valid(:name).with(nil).message('wrong message')
      matcher.matches?(@user).should_not be_false
    end

    it 'returns false when correct message is passed' do
      matcher = @should.have_valid(:name).with(nil).message('is not valid')
      matcher.matches?(@user).should be_false
    end
  end

  describe 'data is first valid then invalid' do
    before do
      @user.stubs(:valid?).returns(true).then.returns(false)
      @user.errors[:name] = ['is not valid']
    end

    it 'returns false' do
      matcher = @should.have_valid(:name).with('true', 'false')
      matcher.matches?(@user).should be_false
    end
  end

  describe 'failure message' do
    before do
      @user.stubs(:valid?).returns(false)
      @user.errors[:name] = ['is not valid']
    end

    it 'has a message for string values' do
      matcher = @should.have_valid(:name).with('Brian')
      matcher.matches?(@user)
      matcher.failure_message.should == " expected User#name to accept a value of 'Brian'"
    end

    it 'has a message for non string values' do
      matcher = @should.have_valid(:name).with(123)
      matcher.matches?(@user)
      matcher.failure_message.should == " expected User#name to accept a value of 123"
    end
  end

  describe 'negative failure message' do
    before do
      @user.stubs(:valid?).returns(false)
      @user.errors[:name] = ['is not valid']
    end

    it 'has a message for string values' do
      matcher = @should.have_valid(:name).with('Brian')
      matcher.matches?(@user)
      matcher.negative_failure_message.should == " expected User#name to not accept a value of 'Brian'"
    end

    it 'has a message for non string values' do
      matcher = @should.have_valid(:name).with(123)
      matcher.matches?(@user)
      matcher.negative_failure_message.should == " expected User#name to not accept a value of 123"
    end

    it 'includes the validation message' do
      matcher = @should.have_valid(:name).with('Brian').message('is not valid')
      matcher.matches?(@user)
      matcher.negative_failure_message.should == " expected User#name to not accept a value of 'Brian' with a message of 'is not valid'"
    end
  end

  it 'requires .with to always be used' do
    matcher = @should.have_valid(:name)
    expect do
      matcher.matches?(@user)
    end.to raise_error ValidAttribute::NoValues, "you need to set the values with .with on the matcher (ex. it { should have_valid(:name).with('Brian') })"
  end

end

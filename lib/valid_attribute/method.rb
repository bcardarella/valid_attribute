module ValidAttribute
  module Method
    # Assert an attribute is valid with any number of test values
    #
    # examples:
    #  describe User do
    #    it { should have_valid(:name).when('Brian') }
    #    it { should_not have_valid(:name).when(nil) }
    #
    #    # if we want to test uniqueness we need to setup an existing value
    #    context 'email' do
    #      before { User.create(:email => 'brian@test.com') }
    #      it { should have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
    #      it { should_not have_valid(:email).when('abc', 123, 'brian@test.com') }
    #    end
    #  end
    #
    # If you are using Test::Unit you should use {http://thoughtbot.com Thoughtbot}'s {https://github.com/thoughtbot/shoulda-context shoulda-context}:
    #  class UserTest < Test::Unit::TestCase
    #    should have_valid(:name).when('Brian')
    #    should_not have_valid(:name).when('nil')
    #
    #    # if we want to test uniqueness we need to setup an existing value
    #    context 'email' do
    #      setup { User.create(:email => 'brian@test.com') }
    #      should have_valid(:email).when('test@test.com', 'test+spam@gmail.com')
    #      should_not have_valid(:email).when('abc', 123, 'brian@test.com')
    #    end
    #  end
    #
    # @param [Symbol]
    #
    # @return [ValidAttribute::Matcher]
    def have_valid(attr)
      ::ValidAttribute::Matcher.new(attr)
    end
  end
end

# ValidAttribute #

ValidAttribute is a minimalist framework for validation BDD.

## Installation ##

If you're using Rails just add the library to your Gemfile

    gem 'valid_attribute'

Then add it to your spec_helper

   require 'valid_attribute'

## Usage ##

Instead of having validation specific matchers ValidAttribute only cares if the attribute is valid under certain circumstances

    class User
      include ActiveModel::Validations

      attr_accessor :email, :name, :password

      validates :email,    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => 'invalid email format' }
      validates :name,     :length => { :minimum => 5 }
      validates :password, :confirmation => true, :presence => true
    end

    describe User do
      # The .with method can take any number of values that you want to pass
      it { should have_valid(:email).with('test@test.com', 'test+spam@gmail.com') }
      it { should_not have_valid(:email).with('fail', 123).message('invalid email format') }
      it { should have_valid(:name).with('TestName')
      it { should_not have_valid(:name).with('Test')

      # Because 'should' works off the the 'subject' in RSpec we can set other values if necessary for a given validation test
      describe 'password' do
        before { subject.password_confirmation = 'password' }
        it { should have_valid(:password).with('password') }
        # Not providing '.with' defaults to nil
        it { should_not have_valid(:password) }
      end
    end

## Legal ##

Brian Cardarella &copy; 2011

[@bcardarella](http://twitter.com/bcardarella)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)

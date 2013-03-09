# ValidAttribute #

[![Build Status](https://secure.travis-ci.org/bcardarella/valid_attribute.png?branch=master)](http://travis-ci.org/bcardarella/valid_attribute)
[![Dependency Status](https://gemnasium.com/bcardarella/valid_attribute.png?travis)](https://gemnasium.com/bcardarella/valid_attribute)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/bcardarella/valid_attribute)

ValidAttribute is a minimalist matcher for validation BDD.

Supported ORMs

* ActiveModel based (ActiveRecord >= 3.0, Mongoid >= 2.0, MongoMapper >= 0.9)
* ActiveRecord <= 2.3
* DataMapper
* Custom (with compatible API, see below)

## Installation ##

If you're using `RSpec` just add the `valid_attribute` to your `Gemfile` AFTER rspec gem.

```ruby
gem 'valid_attribute'
```

Then add it to your `spec_helper.rb`

```ruby
require 'valid_attribute'
```

or if you're using `Test::Unit`, you must use [Thoughtbot](http://thoughtbot.com)'s [shoulda-context](https://github.com/thoughtbot/shoulda-context)

```ruby
# Gemfile
gem 'shoulda-context'

# test_helper.rb
require 'shoulda-context'
require 'valid_attribute'
```

If you want to you use it with `MiniTest::Spec` you can use either `shoulda-context` (see above) or [minitest-matchers](https://github.com/zenspider/minitest-matchers):

```ruby
# Gemfile
gem 'minitest-matchers'

# test_helper.rb
require 'valid_attribute'
```

## Usage ##

Instead of having validation specific matchers `ValidAttribute` only cares if the attribute is valid under certain circumstances

```ruby
class User
  include ActiveModel::Validations

  attr_accessor :email, :name, :password

  validates :email,    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :name,     :length => { :minimum => 5 }
  validates :password, :confirmation => true, :presence => true
end

# RSpec
describe User do
  # The .when method can take any number of values that you want to pass
  it { should have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
  it { should_not have_valid(:email).when('fail', 123) }
  it { should have_valid(:name).when('TestName') }
  it { should_not have_valid(:name).when('Test') }

  # Because 'should' works off the the 'subject' in RSpec we can set other values if necessary for a given validation test
  describe 'password' do
    before { subject.password_confirmation = 'password' }
    it { should have_valid(:password).when('password') }
    it { should_not have_valid(:password).when(nil) }
  end

  # Using .when is optional. Without it, the existing value is examined.
  it { should_not have_valid(:email) }
end

# TestUnit
require 'shoulda/context'
class UserTest < Test::Unit::TestCase
  # The .when method can take any number of values that you want to pass
  should have_valid(:email).when('test@test.com', 'test+spam@gmail.com')
  should_not have_valid(:email).when('fail', 123)
  should have_valid(:name).when('TestName')
  should_not have_valid(:name).when('Test')

  # Because 'shoulda-context' works off the 'subject' we can set other values if necessary for a given validation test
  context 'password' do
    subject { User.new(:password_confirmation => 'password') }
    should have_valid(:password).when('password')
    should_not have_valid(:password).when(nil)
  end

  # Using .when is optional. Without it, the existing value is examined.
  should_not have_valid(:email)
end

# Minitest::Matchers
require 'minitest/matchers'
describe User do
  subject { User.new }

  it { must have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
  it { wont have_valid(:email).when('fail', 123) }
  it { must have_valid(:name).when('TestName') }
  it { wont have_valid(:name).when('Test') }

  describe 'password' do
    subject { User.new.tap { |u| u.password_confirmation = "password" } }
    it { must have_valid(:password).when('password') }
    it { wont have_valid(:password).when(nil) }
  end
end
```

## Custom Models ##

Your model should respond to the following methods:

* `valid?` - only used to generate errors on the model
* `errors` - should be a Hash of attributes that have the invalid attributes as keys.

The following would be a compatible (albeit unrealistic) model:

```ruby
class User
  attr_accessor :name

  def errors
    {:name => ["can't be blank"]}
  end

  def valid?
    false
  end
end
```

## Don't Repeat Yourself ##

```ruby
# encoding: utf-8

# RSpec
describe User do
  let(:names) { ['TestName', 'Test-name', "O'Namey", 'Maček'] }
  it { should have_valid(:first_name).when *names }
  it { should have_valid(:last_name).when *names }
end
```


## Cloning ##

If you feel that the setters are mutating parts of the object when
testing multiple values you can force the test subject be cloned in
between each test

```ruby
it { should have_valid(:name).when('Brian').clone }
```

Be aware the cloning can cause some unpredicatable results and may lead
to more pain than help

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2012

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)

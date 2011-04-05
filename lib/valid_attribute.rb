module ValidAttribute
  class NoValues < StandardError; end
  # Test if an attribute is valid
  #
  # examples:
  #  it { should have_valid(:name).with('Brian') }
  #  it { should_not have_valid(:name).message("can't be blank") }
  #  it { should have_valid(:email).with('test@test.com', 'test+spam@gmail.com') }
  #
  # @param [Symbol]
  #
  # @return [ValidAttribute::ValidAttributeMatcher]
  def have_valid(attr)
    ValidAttributeMatcher.new(attr)
  end

  class ValidAttributeMatcher
    attr_accessor :attr, :values, :validation_message, :subject, :failed_value

    def initialize(attr)
      self.attr   = attr
    end

    def with(*values)
      self.values = values
      self
    end

    def message(message)
      self.validation_message = message
      self
    end

    def negative_failure_message
      failure_message = " expected #{subject.class.model_name}##{attr} to not accept a value of #{value_message}"

      if validation_message
        failure_message = "#{failure_message} with a message of '#{validation_message}'"
      end

      failure_message
    end

    def failure_message
      " expected #{subject.class.model_name}##{attr} to accept a value of #{value_message}"
    end

    def value_message
      if failed_value.is_a?(String)
        "'#{failed_value}'"
      else
        failed_value
      end
    end

    def matches?(subject)
      unless values
        raise ::ValidAttribute::NoValues, "you need to set the values with .with on the matcher (ex. it { should have_valid(:name).with('Brian') })"
      end

      self.subject = subject

      values.each do |value|
        subject.send("#{attr}=", value)
        subject.valid?

        if subject.errors.include?(attr)
          self.failed_value = value
          if validation_message
            return !subject.errors[attr].include?(validation_message)
          else
            return false
          end
        end
      end

      true
    end

  end
end

module RSpec::Matchers
  include ValidAttribute
end if defined?(RSpec)


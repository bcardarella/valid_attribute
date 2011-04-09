module ValidAttribute
  class NoValues < StandardError; end
  # Test if an attribute is valid
  #
  # examples:
  #  it { should have_valid(:name).when('Brian') }
  #  it { should_not have_valid(:name).when(nil) }
  #  it { should have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
  #  it { should_not have_valid(:email).when('abc', 123) }
  #
  # @param [Symbol]
  #
  # @return [ValidAttribute::ValidAttributeMatcher]
  def have_valid(attr)
    ValidAttributeMatcher.new(attr)
  end

  class ValidAttributeMatcher
    attr_accessor :attr, :values, :subject, :failed_values, :passed_values

    def initialize(attr)
      self.attr          = attr
      self.failed_values = []
      self.passed_values = []
    end

    def when(*values)
      self.values = values
      self
    end

    def failure_message
      if failed_values.size == 1
        " expected #{subject.class.model_name}##{attr} to accept the value: #{quote_values(failed_values)}"
      else
        " expected #{subject.class.model_name}##{attr} to accept the values: #{quote_values(failed_values)}"
      end
    end

    def negative_failure_message
      if passed_values.size == 1
        " expected #{subject.class.model_name}##{attr} to not accept the value: #{quote_values(passed_values)}"
      else
        " expected #{subject.class.model_name}##{attr} to not accept the values: #{quote_values(passed_values)}"
      end
    end

    def matches?(subject)
      unless values
        raise ::ValidAttribute::NoValues, "you need to set the values with .when on the matcher (ex. it { should have_valid(:name).when('Brian') })"
      end

      self.subject = subject

      values.each do |value|
        subject.send("#{attr}=", value)
        subject.valid?
        if subject.errors.key?(attr)
          self.failed_values << value
        else
          self.passed_values << value
        end
      end

      failed_values.empty?
    end

    private

    def quote_values(values)
      values.map { |value| value.is_a?(String) ? "'#{value}'" : value }.join(', ')
    end

  end
end

module RSpec::Matchers
  include ValidAttribute
end if defined?(RSpec)


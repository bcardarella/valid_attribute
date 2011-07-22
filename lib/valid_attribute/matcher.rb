module ValidAttribute
  class Matcher
    attr_accessor :attr, :values, :subject, :failed_values, :passed_values

    def initialize(attr)
      self.attr = attr
    end

    def when(*values)
      self.values = values
      self
    end

    def failure_message
      if failed_values.size == 1
        " expected #{subject.class}##{attr} to accept the value: #{quote_values(failed_values)}"
      else
        " expected #{subject.class}##{attr} to accept the values: #{quote_values(failed_values)}"
      end
    end

    def negative_failure_message
      if passed_values.size == 1
        " expected #{subject.class}##{attr} to reject the value: #{quote_values(passed_values)}"
      else
        " expected #{subject.class}##{attr} to reject the values: #{quote_values(passed_values)}"
      end
    end

    def description
      "be valid when #{attr} is: #{quote_values(values)}"
    end

    def matches?(subject)
      check_values(subject)
      failed_values.empty?
    end

    def does_not_match?(subject)
      check_values(subject)
      !failed_values.empty? && passed_values.empty?
    end

    private

    def check_values(subject)
      self.subject       = subject
      self.failed_values = []
      self.passed_values = []

      if values
        check_specified_values
      else
        check_existing_value
      end
    end

    def check_specified_values
      values.each do |value|
        check_value value
      end
    end

    def check_existing_value
      check_value subject.send("#{attr}")
    end

    def check_value(value)
      cloned_subject = subject.clone
      cloned_subject.send("#{attr}=", value)
      cloned_subject.valid?

      if invalid_attribute?(cloned_subject, attr)
        self.failed_values << value
      else
        self.passed_values << value
      end
    end

    def invalid_attribute?(cloned_subject, attr)
      errors = cloned_subject.errors[attr]
      errors.respond_to?(:empty?) ? !errors.empty? : !!errors
    end

    def quote_values(values)
      values.map { |value| value.inspect }.join(', ')
    end

  end
end

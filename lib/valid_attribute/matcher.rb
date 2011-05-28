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

    def description
      "be valid when: #{quote_values(values)}"
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
      unless values
        raise ::ValidAttribute::NoValues, "you need to set the values with .when on the matcher. Example: have_valid(:name).when('Brian')"
      end

      self.subject       = subject
      self.failed_values = []
      self.passed_values = []

      values.each do |value|
        subject.send("#{attr}=", value)
        subject.valid?
        if subject.errors.key?(attr)
          self.failed_values << value
        else
          self.passed_values << value
        end
      end
    end

    def quote_values(values)
      values.map { |value| value.is_a?(String) ? "'#{value}'" : value }.join(', ')
    end

  end
end

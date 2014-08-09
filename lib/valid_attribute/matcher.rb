module ValidAttribute
  class Matcher
    attr_accessor :attr, :subject, :failed_values, :passed_values
    attr_writer :values

    def initialize(attr)
      self.attr = attr
      @clone = nil
    end

    # The collection of values to test against for the given
    # attribute
    #
    # @params [Array]
    #
    # @return [ValidAttribute::Matcher]
    def when(*values)
      self.values = values
      self
    end

    def failure_message
      message(failed_values, 'accept')
    end

    def negative_failure_message
      message(passed_values, 'reject')
    end
    alias failure_message_when_negated negative_failure_message

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

    def clone?
      !!@clone
    end

    # Force the matcher to clone the subject in between
    # testing each value.
    #
    # *Warning* This could lead to unintended results. The clone
    # is not a deep copy
    #
    # @return [ValidAttribute::Matcher]
    def clone
      @clone = true
    end

    private

    def check_values(subject)
      self.subject       = subject
      self.failed_values = []
      self.passed_values = []

      values.each do |value|
        check_value value
      end
    end

    def values
      @values ||= [subject.send(attr)]
    end

    def check_value(value)
      _subject = clone? ? subject.clone : subject
      _subject.send("#{attr}=", value)
      _subject.valid?

      if invalid_attribute?(_subject, attr)
        self.failed_values << value
      else
        self.passed_values << value
      end
    end

    def invalid_attribute?(_subject, attr)
      errors = _subject.errors[attr]
      errors.respond_to?(:empty?) ? !errors.empty? : !!errors
    end

    def quote_values(values)
      values.map { |value| value.inspect }.join(', ')
    end

    def message(values, verb)
      " expected #{subject.class}##{attr} to #{verb} the value#{values.size == 1 ? nil : 's'}: #{quote_values(values)}"
    end
  end
end

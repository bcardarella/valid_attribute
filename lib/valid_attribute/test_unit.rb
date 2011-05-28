class Test::Unit::TestCase
  class << self
    def have_valid(attr)
      ValidAttribute::ValidAttributeMatcher.new(attr)
    end
  end
end

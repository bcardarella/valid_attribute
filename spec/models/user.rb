class User
  attr_accessor :name
  attr_accessor :email

  def errors
    @error ||= {}
  end

  def valid?
    errors.empty?
  end
end

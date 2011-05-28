class User
  attr_accessor :name
  attr_accessor :email

  def errors
    @error ||= {}
  end

  def self.model_name
    'User'
  end
end

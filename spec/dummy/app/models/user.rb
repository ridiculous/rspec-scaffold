class User < ActiveRecord::Base
  include self::Auth

  def self.class_method_example
    return false
  end

  def instance_method_example
    return true
  end

end

class User < ActiveRecord::Base
  module Auth
    extend ActiveSupport::Concern

    def has_access?
      return "2017-01-01".to_datetime < Time.now
    end

  end
end

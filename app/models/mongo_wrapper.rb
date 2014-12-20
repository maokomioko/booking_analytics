module MongoWrapper
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    #include Mongoid::Timestamps::Created
    #include Mongoid::Timestamps::Updated
  end
end

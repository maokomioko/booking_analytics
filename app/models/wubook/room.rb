class Wubook::Room
  include MongoWrapper

  belongs_to :wubook_auth

  field :name, type: String
  field :max_people, type: Integer
  field :subroom, type: Integer
  field :children, type: Integer
end

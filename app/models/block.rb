class Block < Sequel::Model
  Sequel::Model.plugin :json_serializer
  one_to_many :transactions
end

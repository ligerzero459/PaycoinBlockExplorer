class Transaction < Sequel::Model
  many_to_one :blocks
  one_to_many :inputs
  one_to_many :outputs
end

class Input < Sequel::Model
  one_to_one :transactions
end

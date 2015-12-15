Sequel.migration do 
  change do

    create_table? :inputs do
      primary_key :id
      Fixnum :transaction_id
      Fixnum :outputTransactionId
      String :outputTxid
      Float :value
      index :transaction_id
      index :outputTransactionId
    end

  end
end
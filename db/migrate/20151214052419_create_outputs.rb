Sequel.migration do 
  change do

    create_table? :outputs do
      primary_key :id
      Fixnum :transaction_id
      Fixnum :n
      String :script
      String :type
      String :address
      Float :value
      index :address
      index [:transaction_id, :value]
    end

  end
end
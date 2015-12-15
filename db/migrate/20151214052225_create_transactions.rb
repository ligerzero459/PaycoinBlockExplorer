Sequel.migration do 
  change do

    create_table? :transactions do
      primary_key :id
      String :txid
      Fixnum :block_id
      String :type
      Float :totalOutput
      Float :fees
      index :txid
      index :block_id
    end

    create_table? :raw_transactions do
      primary_key :id
      String :txid
      File :raw
      index :txid
    end

  end
end
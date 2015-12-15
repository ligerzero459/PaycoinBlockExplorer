Sequel.migration do 
  change do

    create_table? :blocks do
      primary_key :id
      String :blockHash
      Fixnum :height, :unique=>true
      DateTime :blockTime
      Float :mint
      String :previousBlockHash
      String :flags
      index :blockHash
      index :height
    end

    create_table? :raw_blocks do
      primary_key :id
      Fixnum :height
      File :raw
      index :height
    end

  end
end
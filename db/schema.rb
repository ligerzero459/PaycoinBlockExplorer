Sequel.migration do
  change do
    create_table(:blocks) do
      primary_key :id
      column :blockHash, "varchar(255)"
      column :height, "integer"
      column :blockTime, "timestamp"
      column :mint, "double precision"
      column :previousBlockHash, "varchar(255)"
      column :flags, "varchar(255)"
      
      index [:blockHash]
      index [:height]
    end
    
    create_table(:inputs) do
      primary_key :id
      column :transaction_id, "integer"
      column :outputTransactionId, "integer"
      column :outputTxid, "varchar(255)"
      column :value, "double precision"
      
      index [:outputTransactionId]
      index [:transaction_id]
    end
    
    create_table(:outputs) do
      primary_key :id
      column :transaction_id, "integer"
      column :n, "integer"
      column :script, "varchar(255)"
      column :type, "varchar(255)"
      column :address, "varchar(255)"
      column :value, "double precision"
      
      index [:address]
      index [:transaction_id, :value]
    end
    
    create_table(:raw_blocks) do
      primary_key :id
      column :height, "integer"
      column :raw, "blob"
      
      index [:height]
    end
    
    create_table(:raw_transactions) do
      primary_key :id
      column :txid, "varchar(255)"
      column :raw, "blob"
      
      index [:txid]
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:transactions) do
      primary_key :id
      column :txid, "varchar(255)"
      column :block_id, "integer"
      column :type, "varchar(255)"
      column :totalOutput, "double precision"
      column :fees, "double precision"
      
      index [:block_id]
      index [:txid]
    end
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20151214051353_create_blocks.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20151214052225_create_transactions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20151214052406_create_inputs.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20151214052419_create_outputs.rb')"
                end
              end

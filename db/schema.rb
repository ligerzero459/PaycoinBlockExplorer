Sequel.migration do
  change do
    create_table(:addresses) do
      primary_key :id, :type=>"int(11)"
      column :address, "varchar(255)"
      column :balance, "double"
      
      index [:address]
    end
    
    create_table(:announcements) do
      primary_key :id, :type=>"int(11)"
      column :announcement, "blob"
      column :active, "tinyint(1)"
      column :createdAt, "datetime"
      column :updatedAt, "datetime"
    end
    
    create_table(:blocks) do
      primary_key :id, :type=>"int(11)"
      column :blockHash, "varchar(255)"
      column :height, "int(11)"
      column :blockTime, "datetime"
      column :mint, "double"
      column :previousBlockHash, "varchar(255)"
      column :flags, "varchar(255)"
      column :nextBlockHash, "varchar(255)"
      column :blockSize, "int(11)"
      column :merkleRoot, "varchar(255)"
      column :difficulty, "double"
      
      index [:blockHash]
      index [:height]
      index [:height], :name=>:height, :unique=>true
    end
    
    create_table(:inputs) do
      primary_key :id, :type=>"int(11)"
      column :transaction_id, "int(11)"
      column :outputTransactionId, "int(11)"
      column :outputTxid, "varchar(255)"
      column :value, "double"
      column :vout, "int(11)"
      column :address, "varchar(255)"
      
      index [:address]
      index [:outputTransactionId]
      index [:transaction_id]
    end
    
    create_table(:ledger) do
      primary_key :id, :type=>"int(11)"
      column :transaction_id, "int(11)"
      column :txid, "varchar(255)"
      column :address, "varchar(255)"
      column :value, "double"
      column :type, "varchar(255)"
      column :n, "int(11)"
      column :balance, "double"
      
      index [:address]
      index [:transaction_id]
      index [:txid]
    end
    
    create_table(:outputs) do
      primary_key :id, :type=>"int(11)"
      column :transaction_id, "int(11)"
      column :n, "int(11)"
      column :script, "varchar(255)"
      column :type, "varchar(255)"
      column :address, "varchar(255)"
      column :value, "double"
      
      index [:address]
      index [:transaction_id, :value]
    end
    
    create_table(:outstanding_coins) do
      primary_key :id, :type=>"int(11)"
      column :coinSupply, "double"
      column :createdAt, "datetime"
      column :updatedAt, "datetime"
    end
    
    create_table(:raw_blocks) do
      primary_key :id, :type=>"int(11)"
      column :height, "int(11)"
      column :raw, "longblob"
      
      index [:height]
    end
    
    create_table(:raw_transactions) do
      primary_key :id, :type=>"int(11)"
      column :txid, "varchar(255)"
      column :raw, "longblob"
      
      index [:txid]
    end
    
    create_table(:schema_info) do
      column :version, "int(11)", :default=>0, :null=>false
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:transactions) do
      primary_key :id, :type=>"int(11)"
      column :txid, "varchar(255)"
      column :block_id, "int(11)"
      column :type, "varchar(255)"
      column :totalOutput, "double"
      column :fees, "double"
      column :coinbase, "tinyint(1)", :default=>false
      column :coinstake, "tinyint(1)", :default=>false
      
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
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160130173955_create_addresses.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20160202030646_announcement.rb')"
                end
              end

Sequel.migration do 
  change do

    create_table? :searches do
      primary_key :id
    end

  end
end

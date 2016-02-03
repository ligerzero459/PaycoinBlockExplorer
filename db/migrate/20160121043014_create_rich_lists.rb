Sequel.migration do 
  change do

    create_table? :rich_lists do
      primary_key :id
    end

  end
end

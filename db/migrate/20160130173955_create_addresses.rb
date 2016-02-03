Sequel.migration do 
  change do

    create_table? :addresses do
      primary_key :id
    end

  end
end

Sequel.migration do
  up do
    create_table? :announcements do
      primary_key :id
      File :announcement
      boolean :active
      DateTime :createdAt
      DateTime :updatedAt
    end
  end

  down do
    drop_table :announcements
  end
end

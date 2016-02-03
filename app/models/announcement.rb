class Announcement < Sequel::Model
  Announcement.plugin :timestamps, :force=>true, :update_on_create=> true, :create=>:createdAt, :update=>:updatedAt
end

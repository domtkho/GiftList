json.extract! @list, :id, :user_id, :wanted_items
json.wanted_items @list.wanted_items do |wanted_item|
  json.extract! wanted_item, :item, :priority, :id
end
json.extract! @list_owner, :email, :name, :uid, :image
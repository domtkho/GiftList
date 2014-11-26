json.extract! @list, :id, :user_id
json.wanted_items @list.wanted_items do |wanted_item|
  json.extract! wanted_item, :item, :priority
end
json.extract! @list_owner, :email, :name, :uid, :image
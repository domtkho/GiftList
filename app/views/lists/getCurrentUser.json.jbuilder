json.extract! @current_user, :name, :email, :image
json.wanted_items(@wanted_items) do |wanted_item|
  json.extract! wanted_item, :item, :id, :comments, :contributions, :priority
end
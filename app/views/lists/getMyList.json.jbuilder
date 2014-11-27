json.wanted_items(@my_list.wanted_items) do |wanted_item|
  json.extract! wanted_item, :item, :id, :comments, :contributions, :priority
end

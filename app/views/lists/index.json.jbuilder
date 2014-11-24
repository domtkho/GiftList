json.array!(@lists) do |list|
  json.extract! list, :id, :user_id
  json.wanted_items list.wanted_items do |wanted_item|
    json.extract! wanted_item, :item
  end
  json.url list_url(list, format: :json)
end

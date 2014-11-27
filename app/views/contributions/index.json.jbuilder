json.array!(@contributions) do |contribution|
  json.extract! contribution, :id, :user_id, :wanted_item_id, :amount
  json.url contribution_url(contribution, format: :json)
end

json.array!(@contributions) do |contribution|
  json.extract! contribution, :id, :user, :amount
end
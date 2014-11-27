json.array!(@comments) do |comment|
  json.extract! comment, :id, :user, :content, :created_at
end
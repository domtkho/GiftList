json.array!(@friends_array) do |friend|
  json.extract! friend, :id, :name, :uid, :email, :image
end
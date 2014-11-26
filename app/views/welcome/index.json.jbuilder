json.array!(@friends_array) do |friend|
  json.extract! friend, :name, :uid, :email, :image
end

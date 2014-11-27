class WelcomeController < ApplicationController
  def index
  end

  def friends
    if user_signed_in?
      @graph = Koala::Facebook::API.new(current_user.facebook_token)
      @friends = @graph.get_connections("me", "friends")
      @friends_array = []

      @friends.each do |friend|
        @friends_array << User.where(uid: friend['id']).first unless User.where(uid: friend['id']).first == nil
      end
    end
  end
end
class WelcomeController < ApplicationController
  def index
    @items = Item.all
    if user_signed_in?
      @lists = current_user.lists.all
      @graph = Koala::Facebook::API.new(current_user.facebook_token)
      @friends = @graph.get_connections("me", "friends")
      @friends_array = []

      @friends.each do |friend|
        @friends_array << User.where(uid: friend['id']).first
      end
    end
  end
end

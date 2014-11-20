require 'rails_helper'

# feature 'Visitor loads root' do
#   scenario 'Load Page' do
#     visit '/'
#     expect(page).to have_content('Sign in with Facebook')
#   end
# end
describe Item do
  before(:each) do
    items = Item.create([
  { name: "Fitbit", image: "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/8681/8681579_sa.jpg;canvasHeight=145;canvasWidth=105" , price: 129.99 , description: "Tracks steps taken, distance traveled, calories burned, stairs climbed, pace, active minutes and sleep metrics; call notifications; OLED; syncs with select computers and smartphones" , category: "Gadget" , rating: 4 },
  { name: "PlayStation 4", image: "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/8240/8240103_sa.jpg;canvasHeight=500;canvasWidth=500" , price: 399.99 , description: "The PS4 is a graphical powerhouse, able to deliver massive game worlds with impressive clarity and detail. 8GB of RAM allows for serious multitasking potential, complementing the great apps and features that make up the PS4 experience. The PlayStation brand of consoles has an impressive history of delivering world-class exclusive games, and the trend is sure to continue with the PS4. The growing blockbuster catalog is backed by a library of free-to-play and indie games, giving you flexibility in how you pay and play. The PS4 also acts as a social hub, with several built-in features that take advantage of the social networks you're already using. The controller's Share button opens up a world of video sharing, with the option to stream your gameplay live or record it to edit and post later.PlayStation Vita owners will enjoy the connectivity that ties the two devices together, from Remote Play, which allows you to play your PS4 games on your Vita's screen over a local Wi-Fi network, to Cross-Buy, which allows you to purchase a game digitally only once and play it on both your PS4 and your Vita." , category: "Gadget" , rating: 5 },
  { name: "iPhone 4s", image: "http://pisces.bbystatic.com/image2/BestBuy_US/images/products/9455/9455205_sa.jpg;canvasHeight=500;canvasWidth=500" , price: 199.99 , description: "iPhone 4s has a 3.5-inch Retina display, an 8MP iSight camera with 1080p HD video recording, a FaceTime camera, and long battery life. And with iOS 7 and iCloud, it does more than ever." , category: "Gadget" , rating: 3 }
  ])
  end
end


describe "the search function", :type => :feature do
  it "searches for an item" do
    visit '/'
    fill_in('search', :with => 'iPhone')
    click_button('Search')
    within('tbody') do
      expect(page).to have_content('iPhone')
    end
  end
end


# feature 'User searches for item' do
#   within("#session") do
#     fill_in('item', :with => 'iphone')
#     click_button('Search')
#   end
#   expect(page).to have_content('iPhone')
# end

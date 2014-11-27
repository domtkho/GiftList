require 'rails_helper'

RSpec.describe "contributions/index", :type => :view do
  before(:each) do
    assign(:contributions, [
      Contribution.create!(
        :user => nil,
        :wanted_item => nil,
        :amount => 1.5
      ),
      Contribution.create!(
        :user => nil,
        :wanted_item => nil,
        :amount => 1.5
      )
    ])
  end

  it "renders a list of contributions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end

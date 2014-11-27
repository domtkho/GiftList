require 'rails_helper'

RSpec.describe "contributions/edit", :type => :view do
  before(:each) do
    @contribution = assign(:contribution, Contribution.create!(
      :user => nil,
      :wanted_item => nil,
      :amount => 1.5
    ))
  end

  it "renders the edit contribution form" do
    render

    assert_select "form[action=?][method=?]", contribution_path(@contribution), "post" do

      assert_select "input#contribution_user_id[name=?]", "contribution[user_id]"

      assert_select "input#contribution_wanted_item_id[name=?]", "contribution[wanted_item_id]"

      assert_select "input#contribution_amount[name=?]", "contribution[amount]"
    end
  end
end

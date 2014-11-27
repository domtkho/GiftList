require 'rails_helper'

RSpec.describe "contributions/show", :type => :view do
  before(:each) do
    @contribution = assign(:contribution, Contribution.create!(
      :user => nil,
      :wanted_item => nil,
      :amount => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/1.5/)
  end
end

require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        name: "Name",
        value: "9.99",
        obs: "MyText",
        stoc: false
      ),
      Project.create!(
        name: "Name",
        value: "9.99",
        obs: "MyText",
        stoc: false
      )
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end

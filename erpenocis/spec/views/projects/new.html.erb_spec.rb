require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      name: "MyString",
      value: "9.99",
      obs: "MyText",
      stoc: false
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input[name=?]", "project[name]"

      assert_select "input[name=?]", "project[value]"

      assert_select "textarea[name=?]", "project[obs]"

      assert_select "input[name=?]", "project[stoc]"
    end
  end
end

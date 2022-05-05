require 'rails_helper'

RSpec.describe "projects/edit", type: :view do
  before(:each) do
    @project = assign(:project, Project.create!(
      name: "MyString",
      value: "9.99",
      obs: "MyText",
      stoc: false
    ))
  end

  it "renders the edit project form" do
    render

    assert_select "form[action=?][method=?]", project_path(@project), "post" do

      assert_select "input[name=?]", "project[name]"

      assert_select "input[name=?]", "project[value]"

      assert_select "textarea[name=?]", "project[obs]"

      assert_select "input[name=?]", "project[stoc]"
    end
  end
end

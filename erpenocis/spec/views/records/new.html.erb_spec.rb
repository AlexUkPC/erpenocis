require 'rails_helper'

RSpec.describe "records/new", type: :view do
  before(:each) do
    assign(:record, Record.new(
      record_type: "MyString",
      location: "MyString",
      initial_data: "MyString",
      modified_data: "MyString",
      user: nil
    ))
  end

  it "renders new record form" do
    render

    assert_select "form[action=?][method=?]", records_path, "post" do

      assert_select "input[name=?]", "record[record_type]"

      assert_select "input[name=?]", "record[location]"

      assert_select "input[name=?]", "record[initial_data]"

      assert_select "input[name=?]", "record[modified_data]"

      assert_select "input[name=?]", "record[user_id]"
    end
  end
end

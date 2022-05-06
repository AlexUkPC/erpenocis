require 'rails_helper'

RSpec.describe "records/index", type: :view do
  before(:each) do
    assign(:records, [
      Record.create!(
        record_type: "Record Type",
        location: "Location",
        initial_data: "Initial Data",
        modified_data: "Modified Data",
        user: nil
      ),
      Record.create!(
        record_type: "Record Type",
        location: "Location",
        initial_data: "Initial Data",
        modified_data: "Modified Data",
        user: nil
      )
    ])
  end

  it "renders a list of records" do
    render
    assert_select "tr>td", text: "Record Type".to_s, count: 2
    assert_select "tr>td", text: "Location".to_s, count: 2
    assert_select "tr>td", text: "Initial Data".to_s, count: 2
    assert_select "tr>td", text: "Modified Data".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end

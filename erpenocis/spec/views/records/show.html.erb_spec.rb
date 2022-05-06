require 'rails_helper'

RSpec.describe "records/show", type: :view do
  before(:each) do
    @record = assign(:record, Record.create!(
      record_type: "Record Type",
      location: "Location",
      initial_data: "Initial Data",
      modified_data: "Modified Data",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Record Type/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Initial Data/)
    expect(rendered).to match(/Modified Data/)
    expect(rendered).to match(//)
  end
end

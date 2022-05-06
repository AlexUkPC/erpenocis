require 'rails_helper'

RSpec.describe "cars/index", type: :view do
  before(:each) do
    assign(:cars, [
      Car.create!(
        number_plate: "Number Plate"
      ),
      Car.create!(
        number_plate: "Number Plate"
      )
    ])
  end

  it "renders a list of cars" do
    render
    assert_select "tr>td", text: "Number Plate".to_s, count: 2
  end
end

require 'rails_helper'

RSpec.describe "cars/show", type: :view do
  before(:each) do
    @car = assign(:car, Car.create!(
      number_plate: "Number Plate"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Number Plate/)
  end
end

require 'rails_helper'

RSpec.describe "cars/edit", type: :view do
  before(:each) do
    @car = assign(:car, Car.create!(
      number_plate: "MyString"
    ))
  end

  it "renders the edit car form" do
    render

    assert_select "form[action=?][method=?]", car_path(@car), "post" do

      assert_select "input[name=?]", "car[number_plate]"
    end
  end
end

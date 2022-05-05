require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    assign(:orders, [
      Order.create!(
        status: 2,
        category: "Category",
        name_type_color: "Name Type Color",
        needed_quantity: 3,
        unit: "Unit",
        cote: "Cote",
        brother_id: "Brother",
        ordered_quantity: 4,
        supplier: nil,
        supplier_contact: "Supplier Contact",
        obs: "MyText",
        project: nil
      ),
      Order.create!(
        status: 2,
        category: "Category",
        name_type_color: "Name Type Color",
        needed_quantity: 3,
        unit: "Unit",
        cote: "Cote",
        brother_id: "Brother",
        ordered_quantity: 4,
        supplier: nil,
        supplier_contact: "Supplier Contact",
        obs: "MyText",
        project: nil
      )
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Category".to_s, count: 2
    assert_select "tr>td", text: "Name Type Color".to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "Unit".to_s, count: 2
    assert_select "tr>td", text: "Cote".to_s, count: 2
    assert_select "tr>td", text: "Brother".to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Supplier Contact".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end

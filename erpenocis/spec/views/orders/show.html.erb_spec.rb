require 'rails_helper'

RSpec.describe "orders/show", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Category/)
    expect(rendered).to match(/Name Type Color/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Unit/)
    expect(rendered).to match(/Cote/)
    expect(rendered).to match(/Brother/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Supplier Contact/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end

require 'rails_helper'

RSpec.describe "orders/edit", type: :view do
  before(:each) do
    @order = assign(:order, Order.create!(
      status: 1,
      category: "MyString",
      name_type_color: "MyString",
      needed_quantity: 1,
      unit: "MyString",
      cote: "MyString",
      brother_id: "MyString",
      ordered_quantity: 1,
      supplier: nil,
      supplier_contact: "MyString",
      obs: "MyText",
      project: nil
    ))
  end

  it "renders the edit order form" do
    render

    assert_select "form[action=?][method=?]", order_path(@order), "post" do

      assert_select "input[name=?]", "order[status]"

      assert_select "input[name=?]", "order[category]"

      assert_select "input[name=?]", "order[name_type_color]"

      assert_select "input[name=?]", "order[needed_quantity]"

      assert_select "input[name=?]", "order[unit]"

      assert_select "input[name=?]", "order[cote]"

      assert_select "input[name=?]", "order[brother_id]"

      assert_select "input[name=?]", "order[ordered_quantity]"

      assert_select "input[name=?]", "order[supplier_id]"

      assert_select "input[name=?]", "order[supplier_contact]"

      assert_select "textarea[name=?]", "order[obs]"

      assert_select "input[name=?]", "order[project_id]"
    end
  end
end

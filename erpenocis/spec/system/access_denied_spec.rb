require 'rails_helper'
RSpec.describe "Access" do
	it "shows login page" do
		visit root_path
		expect(page.text).to match(/Trebuie sa te autentifici pentru a continua/)
	end
end
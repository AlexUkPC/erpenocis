require 'rails_helper'
RSpec.describe "PageViews" do
	it "shows the number of page views" do
		visit root_path
		expect(page.text).to match(/Trebuie sa te autentifici pentru a continua/)
	end
	it "shows that access is denied" do
		visit '/users'
		expect(page.text).to match(/Trebuie sa te autentifici pentru a continua/)
    
	end
	it "shows home page" do
		visit root_path
		expect(page.text).to match(/Enterprise Resource Planning/)
	end
end
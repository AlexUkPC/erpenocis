require 'rails_helper'
TABLE = 'table'
feature "As admin manage users" do
  given(:user) { create(:user, role: 2) }
  scenario "CRUD" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.username
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    click_on "Utilizatori"
  # #Create
  #   click_on "Adauga user"
  #   fill_in "Username", with: "JohnDoe"
  #   fill_in "Email", with: "john.doe@email.com"
  #   click_on "Adauga"
  #   expect(page.text).to match(/User-ul a fost creeat./)
  # #Read
  #   within(TABLE) do
  #     expect(page.text).to match(/JohnDoe/)
  #     within(:css, 'tbody tr', :match => :first) do
  #       click_on("Modifica")
  #     end
  #   end
  #   expect(page.find("#user_username").value).to match(/JohnDoe/)
  #   expect(page.find("#user_email").value).to match(/john.doe@email.com/)
  #   expect(page).to have_select('user_role', selected: 'User Achizitii')
  #   # expect(page).to have_checked_field('user_active')
  #   expect(page.find(:css, "#user_active", visible: false)).to be_checked
  # #Update
  #   select 'User Facturi', from: 'user_role'
  #   page.find(:css, "#user_active", visible: false).set(false)
  #   click_on("Modifica")
  #   expect(page.text).to match(/User-ul a fost modificat./)
  #   within(TABLE) do
  #     within(:css, 'tbody tr', :match => :first) do
  #       click_on("Modifica")
  #     end
  #   end
  #   expect(page).to have_select('user_role', selected: 'User Facturi')
  #   expect(page.find(:css, "#user_active", visible: false)).not_to be_checked
  #   click_on "Anuleaza"
  # #Delete
  #   within(TABLE) do
  #     expect(page.text).to match(/JohnDoe/)
  #     within(:css, 'tbody tr', :match => :first) do
  #       click_on("Modifica")
  #     end
  #   end
  #   click_on "Sterge utilizatorul"
  #   # page.driver.browser.switch_to.alert.accept
  #   # expect(page.text).to match(/User-ul a fost sters./)
  end
end
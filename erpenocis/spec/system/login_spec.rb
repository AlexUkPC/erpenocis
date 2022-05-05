require 'rails_helper'
feature "Log in" do
  given(:user) { create(:user) }
  scenario "succesful with username" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.username
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    expect(page.text).to match(/Autentificare reusita./)
  end
  scenario "succesful with email" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.email
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    expect(page.text).to match(/Autentificare reusita./)
  end
  scenario "failed because of username" do
    visit new_user_session_path
    fill_in "Username / Email", with: "some_random_username"
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    expect(page.text).not_to match(/Autentificare reusita./)
  end
  scenario "failed because of email" do
    visit new_user_session_path
    fill_in "Username / Email", with: "some_random_email@email.com"
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    expect(page.text).not_to match(/Autentificare reusita./)
  end
  scenario "failed because of password" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.email
    fill_in "Parola", with: "some_random_password"
    click_on "LOG IN"
    expect(page.text).not_to match(/Autentificare reusita./)
  end
end
SIDEBAR = 'nav#sidebar'
feature "Log in as admin" do
  given(:user) { create(:user, role: 2) }
  scenario "succesful login as admin" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.username
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    within(SIDEBAR) do
      expect(page).to have_link("Dashboard")
      expect(page).to have_link("Utilizatori")
    end
    visit "/users"
    expect(page.text).not_to match(/Acces interzis admin_only./)
  end
end
feature "Log in as user_achizitii" do
  given(:user) { create(:user, role: 0) }
  scenario "succesful login as user_achizitii" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.username
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    within(SIDEBAR) do
      expect(page).to have_link("Dashboard")
      expect(page).not_to have_link("Utilizatori")
    end
    visit "/users"
    expect(page.text).to match(/Acces interzis admin_only./)
  end
end
feature "Log in as user_facturi" do
  given(:user) { create(:user, role: 1) }
  scenario "succesful login as user_facturi" do
    visit new_user_session_path
    fill_in "Username / Email", with: user.username
    fill_in "Parola", with: user.password
    click_on "LOG IN"
    within(SIDEBAR) do
      expect(page).to have_link("Dashboard")
      expect(page).not_to have_link("Utilizatori")
    end
    visit "/users"
    expect(page.text).to match(/Acces interzis admin_only./)
  end
end

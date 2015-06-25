include Warden::Test::Helpers
Warden.test_mode!

feature 'Sign up', js: true do
  before do
    visit new_user_registration_path
  end

  scenario "User doesn't enter anything" do
    click_on 'Submit'
    expect(page).to have_selector('.form-register .errorHandler', visible: true)
  end

  scenario 'User enter incorrect password confirmation' do
    fill_in :user_email, with: FFaker::Internet.email
    fill_in :user_password, with: '12345678'
    fill_in :user_password_confirmation, with: '87654321'
    click_on 'Submit'

    expect(page).to have_content('Please enter the same value again')
  end

  scenario 'User enters correct data' do
    fill_in :user_email, with: FFaker::Internet.email
    fill_in :user_password, with: '12345678'
    fill_in :user_password_confirmation, with: '12345678'
    fill_in :user_company_attributes_name, with: 'My company'
    find('label[for="agree"]').click
    click_on 'Submit'

    # Capybara::Screenshot.screenshot_and_open_image

    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
  end
end

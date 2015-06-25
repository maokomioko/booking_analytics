include Warden::Test::Helpers
Warden.test_mode!

feature 'Sign in', js: true do
  before do
    visit new_user_session_path
    @user = Fabricate.create(:user)
  end

  scenario "User doesn't enter anything" do
    click_on 'Log in'
    expect(page).to have_selector('.form-login .errorHandler', visible: true)
  end

  scenario "User doesn't enter password" do
    fill_in :user_email, with: @user.email
    click_on 'Log in'

    expect(page).to have_css('.form-group.has-error #user_password + .help-block')
  end

  scenario 'User enters correct data' do
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password

    click_on 'Log in'

    expect(page).not_to have_selector('.form-login .errorHandler', visible: true)
  end
end

feature 'Request password reset', js: true do
  before do
    visit new_user_password_path
    @user = Fabricate.create(:user)
  end

  scenario "User doesn't enter anything" do
    click_on 'Submit'
    expect(page).to have_selector('.form-forgot .errorHandler', visible: true)
  end

  scenario 'User enters wrong email' do
    fill_in :user_email, with: 'abcd@example.org'
    click_on 'Submit'

    expect(page).to have_content('Email not found')
  end

  scenario 'User enters right email' do
    fill_in :user_email, with: @user.email
    click_on 'Submit'

    expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
  end
end

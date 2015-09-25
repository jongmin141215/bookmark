feature 'User sign up' do

  scenario 'I can sign up as a new user' do
    user = build(:user)
    expect { sign_up(user) }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, #{user.email}")
    expect(User.first.email).to eq(user.email)
  end

  scenario 'requires a matching confirmation password' do
    user = build(:user, password_confirmation: '1234')
    expect { sign_up(user) }.not_to change(User, :count)
  end

  scenario 'with a password that does not match' do
    user = build(:user, password_confirmation: '1234')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'with no user email' do
    user = build(:user, email: '')
    expect { sign_up(user) }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with an existing email' do
    user = create(:user)
    sign_up(user)
    user_2 = build(:user)
    expect{ sign_up(user_2) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User sign in' do
  let(:user) do
    User.create(email: 'user@example.com',
                password: 'secret1234',
                password_confirmation: 'secret1234')
  end

  scenario 'with correct credential' do
    sign_in(email: user.email, password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end
end

feature 'User signs out' do
  before(:each) do
    User.create(email: 'test@test.com',
                password: 'test',
                password_confirmation: 'test')
  end

  scenario 'while being signed in' do
    sign_in(email: 'test@test.com', password: 'test')
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content('Welcome, test@test.com')
  end
end

feature 'Password reset' do
  scenario 'requesting a password reset' do
    user = User.create(email: 'test@test.com', password: 'secret1234',
                       password_confirmation: 'secret1234')
    visit '/password_reset'
    fill_in 'email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)
    expect(user.password_token).not_to be_nil
    expect(page).to have_content 'Check your emails'
  end

  scenario 'resetting password' do
    User.create(email: 'test@test.com', password: 'secret1234',
                password_confirmation: 'secret1234')
    user = User.first
    user.password_token = 'HELLO!'
    user.save

    visit "/users/password_reset/#{user.password_token}"
    expect(page.status_code).to eq 200
    expect(page).to have_content 'Enter a new password'
  end
end

feature 'Viewing links' do
  scenario 'I can see existing links on the links page' do
    Link.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
    visit '/links'

    expect(page.status_code).to eq 200

    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
end

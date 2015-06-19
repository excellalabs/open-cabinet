require 'rails_helper'

RSpec.describe User, type: :model do
  it 'can contain a cabinet' do
    User.create!(email: 'test@test.com', password: 'password', cabinet: Cabinet.new)

    expect(User.first.cabinet.id).to eq(1)
  end
end

require 'rails_helper'

RSpec.describe Medicine, type: :model do
  it 'can be created with the proper attributes' do
    Medicine.create!(set_id: '123456789', name: 'Advil')

    expect(Medicine.first.set_id).to eq('123456789')
  end

  it 'will not be created and throw an error if values are nil' do
    expect { Medicine.create!(set_id: nil, name: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end

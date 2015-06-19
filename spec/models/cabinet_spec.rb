require 'rails_helper'

RSpec.describe Cabinet, type: :model do
  it 'can contain medicines' do
    cabinet = Cabinet.new(medicines: [Medicine.new, Medicine.new])

    expect(cabinet.medicines.length).to eq(2)
  end
end

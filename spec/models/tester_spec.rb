require 'rails_helper'

RSpec.describe Tester, type: :model do
  it 'can return 100' do
    expect(Tester.return_100).to eq(100)
  end

  it 'can return hello' do
    expect(Tester.return_hello).to eq('hello')
  end

  it 'can return goodbye' do
    expect(Tester.return_goodbye).to eq('goodbye')
  end
end

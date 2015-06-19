require 'rails_helper'

RSpec.describe 'medicine/index', type: :view do
  it 'renders search' do
    render
    expect(rendered).to include('OPEN')
    expect(rendered).to include('CABINET')
  end
end

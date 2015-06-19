require 'rails_helper'

RSpec.describe 'drug_search/index', type: :view do
  it 'renders search' do
    render
    expect(rendered).to include('OPEN')
    expect(rendered).to include('CABINET')
  end
end

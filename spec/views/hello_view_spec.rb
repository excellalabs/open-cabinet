require 'rails_helper'

RSpec.describe 'hello/index', type: :view do
  it 'renders hello' do
    render
    expect(rendered).to include('Hello!')
  end
end

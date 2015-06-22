Before('@autocomplete') do
  @home_page = HomePage.new
  @medication = 'autocomplete medication'
  SearchableMedicine.create(name: @medication)
end

Before('@autocomplete') do
  @medication = 'autocomplete medication'
  SearchableMedicine.create(name: @medication)
end

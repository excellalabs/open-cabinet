Before('@autocomplete') do
  @medication = 'Ibuprofen'
  SearchableMedicine.find_or_create_by(name: @medication, set_id: 'ec090526-a623-4e65-8b63-916c49237275')
end

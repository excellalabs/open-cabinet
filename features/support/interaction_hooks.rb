Before('@interaction') do
  Medicine.find_or_create_by(name: 'Ibuprofen', set_id: 'ec090526-a623-4e65-8b63-916c49237275', active_ingredient: '')
  Medicine.find_or_create_by(name: 'Warfarin', set_id: 'e11e4522-4b34-4170-af51-7b602924c746', active_ingredient: '')
  Medicine.find_or_create_by(name: 'Tylenol Cough And Sore Throat', set_id: 'cb64e602-068c-430b-b606-06929a40caaa', active_ingredient: '')
end

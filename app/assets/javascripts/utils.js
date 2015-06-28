function interactions_length(med) {
  if(med.primary in med.all_interactions) {
    return Object.keys(med.all_interactions[med.primary]).length
  } else {
    return 0;
  }
}
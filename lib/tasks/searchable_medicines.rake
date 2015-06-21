namespace :searchable_medicines do
  desc 'Downloads all medicines in the Open FDA dataset using the label endpoint to a file'
  task :download, [:arg1] => [:environment] do |t, args|
    raise 'Please enter a file path for the downloaded file' unless args.arg1 
    parser = SearchableMedicineParser.new(Rails.configuration.open_fda_import_key, 
                                          ImportAutocomplete::FileWriter.new(args.arg1))
    start_time = Time.new(1990, 6, 1)
    finish_time = Time.new
    # finish_time = Time.new(1995, 1, 1)
    parser.pull_searchable_medicines(start_time, finish_time)
  end
  
  desc 'Downloads all medicines in the Open FDA dataset into the database'
  task :import => :environment do
    parser = SearchableMedicineParser.new(Rails.configuration.open_fda_import_key,
                                          ImportAutocomplete::SqlWriter.new)
    start_time = Time.new(1990, 6, 1)
    finish_time = Time.new
    #finish_time = Time.new(1995, 1, 1)
    parser.pull_searchable_medicines(start_time, finish_time)
  end
end
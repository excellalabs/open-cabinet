require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'test@test.com', password: Rails.application.secrets['DEFAULT_USER_PASSWORD'])

SearchableMedicine.delete_all
values = []
CSV.foreach(Rails.root.join('db', 'data').to_s + '/autocomplete.csv').each do |row|
  values.push("(\'#{row[0]}\', now(), now())")
end
sql = "insert into searchable_medicines (name, created_at, updated_at) values #{values.join(', ')}"
SearchableMedicine.connection.execute sql

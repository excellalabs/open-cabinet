module ImportAutocomplete
  class SqlWriter
    def write(data)
      SearchableMedicine.delete_all
      values = []
      data.each do |medicine|
        values.push("(\'#{medicine}\', now(), now())")
      end
      sql = "insert into searchable_medicines (name, created_at, updated_at) values #{values.join(', ')}"
      SearchableMedicine.connection.execute sql
    end
  end
end

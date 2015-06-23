module ImportAutocomplete
  class SqlWriter
    def write(data)
      SearchableMedicine.delete_all
      values = []
      data.each do |medicine_brand, hash|
        values.push("(\'#{medicine_brand}\', \'#{hash[:set_id]}\', now(), now())")
      end
      sql = "insert into searchable_medicines (name, set_id, created_at, updated_at) values #{values.join(', ')}"
      SearchableMedicine.connection.execute sql
    end
  end
end

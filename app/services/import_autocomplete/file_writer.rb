module ImportAutocomplete
  class FileWriter
    def initialize(path)
      @file_path = path
    end

    def write(data)
      Rails.logger.info "Writing #{data.length} rows to #{@file_path}"
      File.write(@file_path, data.join("\n"))
    end
  end
end

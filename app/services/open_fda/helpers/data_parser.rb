module OpenFda
  module Helpers
    module DataParser
      def sanitize(str)
        str.strip.gsub(/\Aand\s/i, '').downcase.titleize
      end

      def split_names(names)
        return {} if names.nil?
        result = {}
        all_names = []
        names.each { |name| all_names.push(*name.split(',')) }
        all_names.each { |name| result[sanitize(name)] = sanitize(name) }
        result
      end

      def tabulate(tabulation, result, data_point)
        tabulation.merge!(split_names(result['openfda'][data_point]))
      end
    end
  end
end

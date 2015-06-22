module OpenFda
  module Helpers
    module DataParser
      def sanitize(str)
        str.strip.gsub(/\Aand\s/i, '').downcase.titleize
      end

      def split_names(names)
        return {} if names.nil?
        result = {}
        names.each do |name|
          name.split(',').each { |n| result[sanitize(n)] = sanitize(n) }
        end
        result
      end

      def tabulate(tabulation, result, data_point)
        tabulation.merge!(split_names(result['openfda'][data_point]))
      end
    end
  end
end

module OpenFda
  module Helpers
    module DataParser
      def sanitize(str)
        str.strip.gsub(/\Aand\s/i, '').downcase.titleize
      end

      def split_names(data, data_point)
        names = data['openfda'][data_point]
        return {} if names.nil?
        result = {}
        names.each do |name|
          name.split(',').each { |n| result[sanitize(n)] = { set_id: data['set_id'] } }
        end
        result
      end

      def tabulate(tabulation, result, data_point)
        tabulation.merge!(split_names(result, data_point))
      end
    end
  end
end

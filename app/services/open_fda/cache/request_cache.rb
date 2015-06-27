module OpenFda
  module Cache
    class RequestCache
      def get(request)
        Rails.cache.read(request)
      end

      def set(request, response)
        Rails.cache.write(request, response, expires_in: 2.hour)
      end
    end
  end
end

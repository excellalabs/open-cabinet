module OpenFda
  module Cache
    class RequestCache
      def get(request)
        Rails.cache.read(key(request))
      end

      def set(request, response)
        Rails.cache.write(key(request), response, expires_in: 2.hour)
      end

      private

      def key(request)
        request.url.to_s
      end
    end
  end
end

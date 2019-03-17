module SemaphoreCI
  module API
    class Client
      def initialize(token, url, prefix, link_parser_class)
        @token = token
        @url = url
        @prefix = prefix
        @link_parser = link_parser_class.new

        @conn = Faraday.new(url: @url) do |conn|
          # uncomment to enable Faraday debugging
          # conn.response :logger
          # conn.token_auth token # FIXME: make we work for V2 API
          conn.adapter :semaphore_net_http
        end
      end

      def get(path)
        response = @conn.get(path.prepend(@prefix), auth_token: @token)
        result = json_from(response)

        while (next_link = @link_parser.parse(response).by_rel('next'))
          response = @conn.get(next_link.target.to_s)
          next_result = json_from(response)

          case [result.class, next_result.class]
          when [Array, Array]
            # V2 pagination
            result.concat(next_result)
          when [Hash, Hash]
            # V1 pagination
            next_result.each do |key, value|
              if value.is_a? Array
                result[key].concat(value)
              elsif value.is_a? Hash
                result[key].merge(value)
              else
                result[key] = value
              end
            end
          else raise 'Unsupported API response'
          end
        end

        result
      end

      private

      def json_from(response)
        if (content_type = response['content-type'])
          # should be something like "application/json; charset=utf-8"
          content_type['application/json'] || raise('JSON body expected')
        end

        JSON.parse(response.body)
      end
    end

    class V1 < Client
      def initialize(token)
        super(token, 'https://semaphoreci.com/', '/api/v1', Semlink::Parser)
      end
    end

    class V2 < Client
      def initialize(token)
        super(token, 'https://api.semaphoreci.com/', '/v2', Nitlink::Parser)
      end
    end
  end
end

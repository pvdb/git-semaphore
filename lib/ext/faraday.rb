module Faraday
  class Adapter
    class SemaphoreNetHttp < NetHttp
      def net_http_connection(env)
        connections = (Thread.current[:net_http_connections] ||= {})
        env_key = [env.url.host, env.url.port, env.ssl.verify]
        connections[env_key] ||= begin
                                   super(env).tap { |connection|
                                     # uncomment to enable Net::HTTP debugging
                                     # connection.set_debug_output($stderr)
                                     connection.use_ssl = true
                                     connection.start
                                   }
                                 end
      end
    end

    register_middleware semaphore_net_http: SemaphoreNetHttp
  end
end

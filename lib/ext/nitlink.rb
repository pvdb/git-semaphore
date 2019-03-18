# pagination: "{\"total_entries\":1535,\"total_pages\":77,\"per_page\":20,\"current_page\":1,\"first_page\":true,\"last_page\":false,\"previous_page\":null,\"next_page\":2}"

# {"total_entries"=>1535,
#  "total_pages"=>77,
#  "per_page"=>20,
#  "current_page"=>1,
#  "first_page"=>true,
#  "last_page"=>false,
#  "previous_page"=>nil,
#  "next_page"=>2}

module Semlink
  class Parser
    def parse(response)
      link_collection = Nitlink::LinkCollection.new

      # FIXME: url.query could be nil/""

      if (pagination = response['pagination'])
        pagination = JSON.parse(pagination)

        if (next_page = pagination['next_page'])
          next_url = response.env['url'].dup
          next_url.query = [next_url.query, "page=#{next_page}"].join('&')
          link_collection << Nitlink::Link.new(next_url, 'next', nil, nil)
        end

        if (prev_page = pagination['previous_page'])
          prev_url = response.env['url'].dup
          prev_url.query = [prev_url.query, "page=#{prev_page}"].join('&')
          link_collection << Nitlink::Link.new(prev_url, 'previous', nil, nil)
        end

      end

      link_collection
    end
  end
end

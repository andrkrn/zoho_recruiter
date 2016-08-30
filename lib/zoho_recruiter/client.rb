module ZohoRecruiter
  class Client
    include HTTParty

    base_uri 'https://recruit.zoho.com/recruit/private'

    def initialize(token)
      @auth_token = token
    end

    def get_records(modules, options = {})
      define_default_options(options)

      get_response("/#{options[:format]}/#{modules}/getRecords/", {
        query: permitted_queries(options)
      })
    end

    def get_record_by_id(modules, id, options = {})
      define_default_options(options)
      options[:id] = id

      get_response("/#{options[:format]}/#{modules}/getRecordById/", {
        query: permitted_queries(options)
      })
    end

    private

    def define_default_options(options)
      options[:format]    ||= 'json'
      options[:scope]     ||= 'recruitapi'
      options[:version]   ||= '2'
      options[:authtoken] ||= @authtoken
    end

    def get_response(url, options)
      self.class.get(url, options)
    end

    def permitted_queries(options)
      options.select { |key, value| [:authtoken, :id, :version].include? key }
    end
  end
end
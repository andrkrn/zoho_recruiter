module ZohoRecruiter
  class Client
    include HTTParty
    debug_output $stdout

    base_uri 'https://recruit.zoho.com/recruit/private'

    def initialize(token)
      @authtoken = token
    end

    def get_records(modules, options = {})
      define_default_options(options)

      get_response("/#{options[:format]}/#{modules}/getRecords", {
        query: permitted_generic_queries(options)
      })
    end

    def get_record_by_id(modules, id, options = {})
      define_default_options(options)

      queries = permitted_generic_queries(options).merge(id: id)

      get_response("/#{options[:format]}/#{modules}/getRecordById", {
        query: queries
      })
    end

    def get_modules(options = {})
      define_default_options(options)

      modules = 'Info/getModules'

      get_response("/#{options[:format]}/#{modules}", {
        query: permitted_generic_queries(options)
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

    def permitted_generic_queries(options)
      options.select { |key, value| [:authtoken, :scope, :version].include? key }
    end
  end
end
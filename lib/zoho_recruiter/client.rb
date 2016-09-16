module ZohoRecruiter
  class Client
    include HTTParty
    debug_output $stdout

    base_uri 'https://recruit.zoho.com/recruit/private'

    def initialize(token)
      @authtoken = token
    end

    # getRecords
    # To retrieve all users data specified in the API request
    # https://www.zoho.com/recruit/api-new/api-methods/getRecordsMethod.html
    def get_records(modules, options = {})
      define_default_options(options)

      get_response("/#{options[:format]}/#{modules}/getRecords", {
        query: permitted_generic_queries(options)
      })
    end

    # getRecordById
    # To retrieve individual records by record ID
    # https://www.zoho.com/recruit/api-new/api-methods/getRecordByIdMethod.html
    def get_record_by_id(modules, id, options = {})
      define_default_options(options)

      queries = permitted_generic_queries(options).merge(id: id)

      get_response("/#{options[:format]}/#{modules}/getRecordById", {
        query: queries
      })
    end

    def add_records
    end

    def update_records
    end

    # getNoteTypes
    # To retrieve all note types in the user account which will be useful while adding Notes through API
    # https://www.zoho.com/recruit/api-new/api-methods/getNoteTypesMethod.html
    def get_note_types()

    end

    # getModules
    # To retrieve all modules from Zoho Recruit account
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

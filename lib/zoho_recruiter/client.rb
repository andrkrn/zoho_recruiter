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

      get_response("/json/#{modules}/getRecordById", {
        query: queries
      })
    end

    def add_records(modules, data, options = {})
      options[:scope]     ||= 'recruitapi'
      options[:version]   ||= '2'
      options[:authtoken] ||= @authtoken

      post_request("/xml/#{modules}/addRecords", {
        query: {
          scope: options[:scope],
          version: options[:version],
          authtoken: options[:authtoken],
          xmlData: build_xml(data)
        }
      })
    end

    def update_records(modules, id, data, options = {})
      options[:scope]     ||= 'recruitapi'
      options[:version]   ||= '2'
      options[:authtoken] ||= @authtoken

      post_request("/xml/#{modules}/updateRecords", {
        query: {
          scope: options[:scope],
          version: options[:version],
          authtoken: options[:authtoken],
          id: id,
          xmlData: build_xml(data)
        }
      })
    end

    def associate_job_opening(job_ids, candidate_ids, options = {})
      options[:scope]     ||= 'recruitapi'
      options[:version]   ||= '2'
      options[:authtoken] ||= @authtoken

      post_request("/xml/Candidates/associateJobOpening", {
        query: {
          scope: options[:scope],
          version: options[:version],
          authtoken: options[:authtoken],
          jobIds: job_ids,
          candidateIds: candidate_ids,
          status: options[:status],
          comments: options[:comments]
        }   
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
      options[:scope]     ||= 'recruitapi'
      options[:version]   ||= '2'
      options[:authtoken] ||= @authtoken
    end

    def get_response(url, options)
      self.class.get(url, options)
    end

    def post_request(url, options)
      self.class.post(url, options)
    end

    def permitted_generic_queries(options)
      options.select { |key, value| [:authtoken, :scope, :version].include? key }
    end

    # Build xml data for Zoho Recruiter
    #
    # data = [{
    #   'Posting Title' => 'Sample Job Something',
    #   'Client Name' => '41studio'
    # }, {
    #   'Posting Title' => 'Sample Job Something',
    #   'Client Name' => '41studio'
    # }]
    #
    # build_xml('JobOpenings', data)
    #
    def build_xml(modules, data = {})
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(modules) do
          data.each.with_index(1) do |fields, i|
            xml.row(no: i) do
              fields.each do |key, value|
              xml.FL(value, val: key)
              end
            end
          end
        end
      end
      builder.to_xml
    end
  end
end
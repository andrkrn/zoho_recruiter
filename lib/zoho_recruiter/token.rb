module ZohoRecruiter
  class Token
    include HTTParty

    def initialize(username = nil, password = nil)
      @username = username || ZohoRecruiter.configuration.username
      @password = password || ZohoRecruiter.configuration.password
    end

    def generate
      content = get_api_response_auth_token

      if content.index('RESULT=TRUE').blank?
        # Falsy
      end

      content.scan(/AUTHTOKEN\=(\S*)/i).flatten[0]
    end

    private

    def get_api_response_auth_token
      response = self.class.get('https://accounts.zoho.com/apiauthtoken/nb/create', {
        query: {
          EMAIL_ID: @username,
          PASSWORD: @password,
          SCOPE: 'ZohoRecruit/recruitapi'
        }
      })
      response.body
    end
  end
end

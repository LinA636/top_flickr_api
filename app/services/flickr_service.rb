class FlickrService
    include HTTParty
    base_uri 'https://api.flickr.com/services/rest/'
  
    def initialize
      @api_key = Rails.application.credentials.dig(:flickr, :api_key)
    end
  
    def get_recent_photos
      response = self.class.get('/',
        query: {
          method: 'flickr.photos.getRecent',
          api_key: @api_key,
          format: 'json',
          nojsoncallback: 1
        }
      )
  
      handle_response(response)
    end
  
    private
  
    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        # Handle error
        raise "Flickr API request failed: #{response.code} - #{response.body}"
      end
    end
  end
  
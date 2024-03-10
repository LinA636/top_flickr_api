class PhotosController < ApplicationController
  def index
    console
    url = "https://www.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=#{ENV["flickr_key"]}&user_id=#{params[:flickr_user_id]}&format=json&nojsoncallback=1"
    response = HTTParty.get(url)
    @response = JSON.parse(response.body)

    if @response['stat'] == 'ok'
      @photo_urls = getPhotoURLs(@response)
    end
  end

  private

  def photo_params
      params.require(:photo).permit(:flickr_user_id)
  end

  def getPhotoURLs(response)
    # array containing hashes with the photo details
    photos_array = response['photos']['photo']
    photo_urls = []
    
    photos_array.each do |photo_hash|
      farm_id = photo_hash['farm']
      server_id = photo_hash['server']
      photo_id = photo_hash['id']
      secret = photo_hash['secret']

      photo_urls << "https://farm#{farm_id}.staticflickr.com/#{server_id}/#{photo_id}_#{secret}.jpg"
    end
    
    photo_urls
  end
end

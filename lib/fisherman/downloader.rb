module Fisherman
  class Downloader
    THUMBNAIL_API_URL = 'https://tnl.snapfish.com/assetrenderer/v2/thumbnail/'

    attr_reader :asset

    def initialize(asset)
      @asset = asset
      @thumbnail = false
    end

    def thumbnail?
      @thumbnail
    end

    def download
      response = Faraday.get(asset.hires_url)
      # The Snapfish main CDN sometimes doesn't have older photos. In that case,
      # the only way to get them is via their thumbnail API. We ask for the
      # largest thumbnail we can get. If you were to download this same asset from
      # the site, the large thumbnail is what it would return.
      if response.status == 404
        @thumbnail = true
        begin
          thumbnail_url = File.join(THUMBNAIL_API_URL, asset.snapfish_ref)
          response = Faraday.get(thumbnail_url,
            height: asset.height,
            access_token: Snapfish.token
          )
          if response.status == 302
            response = Faraday.get(response.headers['location'])
          end
        rescue Faraday::ResourceNotFound
          response = nil
        end
      end
      response && response.body
    end
  end
end

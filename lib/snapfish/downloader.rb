module Snapfish
  class Downloader
    THUMBNAIL_API_URL = 'https://tnl.snapfish.com/assetrenderer/v2/thumbnail/'

    attr_reader :asset, :downloaded, :thumbnail, :bytes

    def initialize(asset)
      @asset = asset
      @downloaded = false
      @thumbnail = false
    end

    def download(destination_file)
      response = Faraday.get(asset.hires_url)
      # The Snapfish main CDN sometimes doesn't have older photos. In that case,
      # the only way to get them is via their thumbnail API. We ask for the
      # largest thumbnail we can get. If you were to download this same asset from
      # the site, the large thumbnail is what it would return.
      if response.status == 404
        @thumbnail = true
        connection = Snapfish::Base.connection
        thumbnail_url = File.join(THUMBNAIL_API_URL, asset.snapfish_ref)
        response = connection.get(thumbnail_url, height: asset.height)
        if response.status == 302
          response = Faraday.get(response.headers['location'])
        else
          raise "Could not download asset thumbnail: #{response.body}"
        end
      end
      if response && response.body
        @downloaded = true
        @bytes = reponse.body.size
        write_file(response)
      end
      self
    end

    private

    def write_file(response)
      destination_file.gsub!(
        /\.#{asset.file_extension}$/,
        "_.#{asset.file_extension}"
      )
      File.open(destination_file, 'wb') { |f| f.write(response.body) }
    end
  end
end

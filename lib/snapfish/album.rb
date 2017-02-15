module Snapfish
  class Album < Base
    def self.get(album_id)
      response = connection.get("collection/#{album_id}")
      if response.success?
        Snapfish::Album.new(response.body['entities'].first)
      end
    end

    def id
      json['id']
    end

    def asset_count
      json['assetIdList'].size
    end

    def name
      extract_tag('userTags', 'caption')
    end

    def assets
      album_json = connection.get(album_url,
        assetType: 'ALL',
        limit: asset_count,
        skip: 0,
        sortCriteria: 'dateTaken',
        sortOrder: 'ascending'
      ).body

      album_json['entities'].map do |entity_json|
        Asset.new(entity_json)
      end
    end

    def as_json
      {
        id: id,
        name: name,
        created_at: created_at
      }
    end

    private

    def album_url
      "collection/#{id}/assets"
    end
  end
end

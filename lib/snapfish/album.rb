module Snapfish
  class Album < Base
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
        limit: 100,
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
        name: name,
        created_at: created_at
      }
    end

    private

    def album_url
      "#{id}/assets"
    end
  end
end

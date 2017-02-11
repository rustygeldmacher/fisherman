module Snapfish
  class AlbumCollection < Base
    include Enumerable

    def each
      all.each { |album| yield album }
    end

    private

    def all
      albums_json = connection.get('monthIndex',
        skip: 0,
        limit: 100,
        minCollection: 1000,
        sortOrder: 'descending',
        timezoneOffset: -300
      ).body

      albums_json['entityMap'].keys.flat_map do |entity|
        collections = albums_json['entityMap'][entity]['collectionList']
        collections.map { |collection_json| Album.new(collection_json) }
      end
    end
  end
end

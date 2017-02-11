module Snapfish
  class Base
    attr_reader :json

    def initialize(json = {})
      @json = json
    end

    def self.connection=(connection)
      @@connection = connection
    end

    def self.connection
      @@connection
    end

    def created_at
      create_date = json['createDate']
      if create_date
        Time.at(create_date / 1000, create_date % 1000)
      end
    end

     def updated_at
       update_date = json['updateDate']
       if update_date
         Time.at(update_date / 1000, update_date % 1000)
       end
     end

    private

    def extract_tag(tag_group, tag_name)
      tags = json[tag_group] || []
      tag = tags.find { |t| t['key'] == tag_name }
      if tag
        tag['value']
      end
    end

    def connection
      Snapfish::Base.connection
    end
  end
end

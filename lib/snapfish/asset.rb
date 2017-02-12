module Snapfish
  class Asset < Base
    def id
      json['_id']
    end

    def snapfish_ref
      find_file('THUMBNAIL')['url']
    end

    def filename
      os_metadata = extract_tag('systemTags', 'OS_METADATA')
      if os_metadata && os_metadata = os_metadata['value']
        os_metadata.match(/os.fn=(\S+)/)[1]
      end
    end

    def size
      json['files'].first['size']
    end

    def width
      find_file('HIRES')['width']
    end

    def height
      find_file('HIRES')['height']
    end

    def caption
      extract_tag('userTags', 'caption')
    end

    def file_extension
      File.extname(hires_url).downcase.gsub(/^\./, '')
    end

    def hires_url
      find_file('HIRES')['url']
    end

    def as_json(options = {})
      {
        id: id,
        ref: snapfish_ref,
        filename: filename,
        file_extension: file_extension,
        width: width,
        height: height,
        size: size,
        caption: caption,
        url: hires_url
      }
    end

    private

    def find_file(type)
      json['files'].find { |f| f['fileType'] == type} || {}
    end
  end
end

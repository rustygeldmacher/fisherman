module Snapfish
  class Asset < Base
    def filename
      os_metadata = extract_tag('systemTags', 'OS_METADATA')
      if os_metadata && os_metadata = os_metadata['value']
        os_metadata.match(/os.fn=(\S+)/)[1]
      end
    end

    def caption
      extract_tag('userTags', 'caption')
    end

    def file_extension
      File.extname(hires_url).downcase.gsub(/^\./, '')
    end

    def hires_url
      hires_file = json['files'].find { |f| f['fileType'] == 'HIRES' }
      if hires_file
        hires_file['url']
      end
    end

    def as_json(options = {})
      {
        filename: filename,
        file_extension: file_extension,
        caption: caption,
        url: hires_url
      }
    end
  end
end

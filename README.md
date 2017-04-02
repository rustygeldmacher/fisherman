# Fisherman

A library that wraps Snapfish's unpublished API used on their site. Currently,
only a very few calls are supported, but there seems to be a lot more that
could be implemented. I only needed enough coverage to get all the photo URLs,
but pull requests are welcome for additional API support.

API Usage:

```ruby
require 'fisherman'

# Currently needs an active access token from the site. To get yours, log in,
# open the developer tools and look for the `access_token` header on one of the
# API requests.
access_token = ...
Snapfish.connect(access_token)

# Get all albums -- returns an enumerable collection of Snapfish::Album objects
albums = Snapfish::AlbumCollection.new.to_a

# Print an album's name
puts albums.first.name

# Get all photos from an album
photos = albums.first.assets

# Print a photo's URL
puts photos.first.hires_url
```

Included is a script called `extract_snapfish_albums` which returns information
on all an account's albums, including URLs for downloading high-resolution
photos. To use it:

```bash
> TOKEN=<access_token from site>
> # Output a JSON file describing each ablum
> extract_snapfish_albums --token $TOKEN --output json > albums.json
> # Output a bash script that downloads all album photos
> extract_snapfish_albums --token $TOKEN --output bash > download.sh
```

The generated Bash script will in turn use the `download_snapfish_album` script.
This script takes a token and an album ID and downloads all of the album's 
photos to a directory underneath the current one. The album directory is named
with the date of the album and first, then the title of the album.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rustygeldmacher/fisherman.


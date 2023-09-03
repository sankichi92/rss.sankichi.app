# sankichi92/rss

Generate RSS feeds by scraping websites without RSS support and deploy them to Pages.

- [内閣府 宇宙政策](https://www8.cao.go.jp/space/index.html): https://rss.sankichi.app/cao_space_policy.xml

## Development

### Setup

    $ bundle install

### Generate feeds

    $ bundle exec rake --build-all

### Lint and Test

    $ bundle exec rake rubocop spec

# sankichi92/rss

Generate RSS feeds by scraping websites without RSS support and deploy them to Pages.

- [内閣府 宇宙政策](https://www8.cao.go.jp/space/index.html): https://rss.sankichi.app/cao_space_policy.xml
- [宇宙開発利用部会 配付資料](https://www.mext.go.jp/b_menu/shingi/gijyutu/gijyutu2/059/index.htm): https://rss.sankichi.app/mext_space_wg.xml

## Development

### Setup

    $ bundle install

### Generate feeds

    $ bundle exec rake --build-all

### Lint and Test

    $ bundle exec rake rubocop spec

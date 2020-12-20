# Landscape
{: id="20201220214147-c6piw5c"}

A brand new default theme for [Hexo].
{: id="20201220214147-ujkcxh3"}

- {: id="20201220214147-4pnpex4"}[Preview](http://hexo.io/hexo-theme-landscape/)
{: id="20201220214147-gbuzmqw"}

## Installation
{: id="20201220214147-fu7uioe"}

### Install
{: id="20201220214147-iprep7h"}

```bash
$ git clone https://github.com/hexojs/hexo-theme-landscape.git themes/landscape
```
{: id="20201220214147-nhzc5tg"}

**Landscape requires Hexo 2.4 and above.** If you would like to enable the RSS, the [hexo-generate-feed] plugin is also required.
{: id="20201220214147-nqzxwcr"}

### Enable
{: id="20201220214147-otek74s"}

Modify `theme` setting in `_config.yml` to `landscape`.
{: id="20201220214147-1yqhpw2"}

### Update
{: id="20201220214147-dr55odx"}

```bash
cd themes/landscape
git pull
```
{: id="20201220214147-i8301f4"}

## Configuration
{: id="20201220214147-a5eesxw"}

```yml
# Header
menu:
  Home: /
  Archives: /archives
rss: /atom.xml

# Content
excerpt_link: Read More
fancybox: true

# Sidebar
sidebar: right
widgets:
- category
- tag
- tagcloud
- archives
- recent_posts

# Miscellaneous
google_analytics:
favicon: /favicon.png
twitter:
google_plus:
```
{: id="20201220214147-ceihfxq"}

- {: id="20201220214147-ib4inmv"}**menu** - Navigation menu
- {: id="20201220214147-jwdf2ch"}**rss** - RSS link
- {: id="20201220214147-6j5q6xk"}**excerpt_link** - "Read More" link at the bottom of excerpted articles. `false` to hide the link.
- {: id="20201220214147-warohep"}**fancybox** - Enable [Fancybox]
- {: id="20201220214147-y1uy61j"}**sidebar** - Sidebar style. You can choose `left`, `right`, `bottom` or `false`.
- {: id="20201220214147-4aw6n48"}**widgets** - Widgets displaying in sidebar
- {: id="20201220214147-c9py42x"}**google_analytics** - Google Analytics ID
- {: id="20201220214147-a97o4ny"}**favicon** - Favicon path
- {: id="20201220214147-sx0x914"}**twitter** - Twiiter ID
- {: id="20201220214147-kosh001"}**google_plus** - Google+ ID
{: id="20201220214147-36bevuq"}

## Features
{: id="20201220214147-q60wvl9"}

### Fancybox
{: id="20201220214147-93jzc0g"}

Landscape uses [Fancybox] to showcase your photos. You can use Markdown syntax or fancybox tag plugin to add your photos.
{: id="20201220214147-d5ffx3w"}

```
![img caption](img url)

{% fancybox img_url [img_thumbnail] [img_caption] %}
```
{: id="20201220214147-i5jzzd1"}

### Sidebar
{: id="20201220214147-0w6fgo6"}

You can put your sidebar in left side, right side or bottom of your site by editing `sidebar` setting.
{: id="20201220214147-jbs4mfp"}

Landscape provides 5 built-in widgets:
{: id="20201220214147-n4ktmql"}

- {: id="20201220214147-uki98rd"}category
- {: id="20201220214147-3ouy3gb"}tag
- {: id="20201220214147-17t20xx"}tagcloud
- {: id="20201220214147-83ucw2m"}archives
- {: id="20201220214147-6a4h4bv"}recent_posts
{: id="20201220214147-d6deb9a"}

All of them are enabled by default. You can edit them in `widget` setting.
{: id="20201220214147-ddqjwpf"}

## Development
{: id="20201220214147-ge51oz1"}

### Requirements
{: id="20201220214147-aq2yp10"}

- {: id="20201220214147-ibymwep"}[Grunt] 0.4+
- {: id="20201220214147-ugsmlvc"}Hexo 2.4+
{: id="20201220214147-5ksz717"}

### Grunt tasks
{: id="20201220214147-gwsa6lt"}

- {: id="20201220214147-l4xrfem"}**default** - Download [Fancybox] and [Font Awesome].
- {: id="20201220214147-vn0whva"}**fontawesome** - Only download [Font Awesome].
- {: id="20201220214147-r1hpm0v"}**fancybox** - Only download [Fancybox].
- {: id="20201220214147-1u6gnno"}**clean** - Clean temporarily files and downloaded files.
{: id="20201220214147-lffekoi"}

[Hexo]: https://hexo.io/
[Fancybox]: http://fancyapps.com/fancybox/
[Font Awesome]: http://fontawesome.io/
[Grunt]: http://gruntjs.com/
[hexo-generate-feed]: https://github.com/hexojs/hexo-generator-feed

{: id="20201220214147-sr65jcr" type="doc"}

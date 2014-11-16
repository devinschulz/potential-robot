require 'sanitize'
require 'lib/custom_helpers'
require 'rack/codehighlighter'
require 'pygments'

# for all the media query OCD
require 'sass-media_query_combiner'

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :blog_url, 'http://devinschulz.com'
set :blog_name, 'Devin Schulz'
set :blog_description, 'Makes developing websites simple.'

@date_format_extended = '%FT%T%:z'
@date_format = '%B %d, %Y'

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "articles"

  blog.permalink = "/article/{year}/{month}/{title}.html"
  # Matcher for blog source files
  blog.sources = "/articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tag/{tag}.html"
  # blog.layout = "article"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Page options, layouts, aliases and proxies
###

config[:js_dir] = 'assets/js'
config[:css_dir] = 'assets/css'
config[:images_dir] = 'assets/images'
config[:font_dir] = 'assets/fonts'

set :haml, { :ugly => true, :format => :html5 }
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true
set :url_root, 'http://devinschulz.com'

activate :search_engine_sitemap
activate :directory_indexes
activate :similar
activate :syntax, :line_numbers => true
activate :autoprefixer do |config|
  config.browsers = ['last 4 versions', 'Explorer >= 9, > 5%']
end
activate :ogp do |ogp|
  ogp.namespaces = {
      fb: data.ogp.fb,
      # from data/ogp/fb.yml
      og: data.ogp.og
      # from data/ogp/og.yml
  }
  ogp.base_url = 'http://devinschulz.com'
  ogp.blog = true
end

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
  activate :gzip
  activate :minify_html
  activate :imageoptim
  activate :google_analytics do |ga|
    ga.tracking_id = 'UA-XXXXXXX-X'
    ga.domain_name = 'devinschulz.com'
    ga.minify = true
  end
end

###
# Helpers
###

helpers CustomHelpers

###
# Syntax Highlighting
###

use Rack::Codehighlighter,
    :pygments,
    :element => "pre>code",
    :pattern => /\A:::([-_+\w]+)\s*\n/,
    :markdown => true


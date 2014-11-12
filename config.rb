require 'sanitize'
require 'lib/custom_helpers'
require 'rack/codehighlighter'
require 'pygments'

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :blog_url, 'http://devinschulz.com'
set :blog_name, 'Devin Schulz'
set :blog_description, 'Makes developing websites simple.'

@analytics_account = false

###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "articles"

  blog.permalink = "{year}/{month}/{title}.html"
  # Matcher for blog source files
  blog.sources = "/articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tags/{tag}.html"
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

activate :directory_indexes
activate :similar

configure :development do
  activate :livereload
end

config[:js_dir] = 'assets/js'
config[:css_dir] = 'assets/css'
config[:images_dir] = 'assets/images'
config[:font_dir] = 'assets/fonts'

set :haml, { :ugly => true, :format => :html5 }

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
  activate :gzip
  activate :minify_html
  activate :imageoptim
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
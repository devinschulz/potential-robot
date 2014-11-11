require 'sanitize'

###
# Site Settings
###
# Set site setting, used in helpers / sitemap.xml / feed.xml.
set :blog_url, 'http://www.example.com'
set :blog_name, 'Devin Schulz'
set :blog_description, 'Makes developing websites simple.'
set :author_name, 'Middleman'
set :author_bio, 'Middleman is a static site generator using all the shortcuts and tools in modern web development.'
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

set :haml, { :ugly => true, :format => :html5 }

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
  activate :gzip
  activate :minify_html
  activate :imageoptim

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

helpers do

  def link_to_page(name, url)
    path = request.path
    current = path =~ Regexp.new('^' + url[1..-1] + '.*\.html')

    if path == 'index.html' and name == 'about'
      current = true
    end

    class_name = current ? ' class="active"' : ''

    "<li#{class_name}><a href=\"#{url}\">#{name}</a></li>"
  end

  def page_classes
    classes = super
    return 'not-found' if classes == '404'
    classes
  end

  def page_title
    title = blog_name.dup
    if current_page.data.title
      title << ": #{current_page.data.title}"
    elsif is_blog_article?
      title << ": #{current_article.title}"
    end
    title
  end

  def page_description
    description = blog_description

    if current_article && current_article.summary(100)
      description = current_article.summary(100)
    end

    description
  end

  def summary(article)
    Sanitize.clean(article.summary, whitespace_elements: %w(h1))
  end

  def current_article_url
    URI.join(blog_url, current_article.url)
  end

  def twitter_url
    "https://twitter.com/share?text=#{current_article.title}&amp;url=#{current_article_url}"
  end

  def facebook_url
    "https://www.facebook.com/sharer/sharer.php?u=#{current_article_url}"
  end

  def google_plus_url
    "https://plus.google.com/share?url=#{current_article_url}"
  end

  def feed_path
    '/feed.xml'
  end

end
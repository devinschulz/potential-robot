module CustomHelpers

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
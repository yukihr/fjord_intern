###
# Blog settings
###
Time.zone = "Tokyo"

activate :syntax

activate :blog do |blog|
  #blog.prefix = "blog"
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = "articles/:year-:month-:day-:title.html"
  blog.default_extension = ".md.erb"
  blog.taglink = "tags/:tag.html"
  blog.layout = "_layouts/article"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 120
  blog.year_link = ":year.html"
  blog.month_link = ":year/:month.html"
  blog.day_link = ":year/:month/:day.html"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = false
  # blog.per_page = 12
  # blog.page_link = "page/:num"
end

page "blog/feed.xml", :layout => false
# page "/sitemap.xml", :layout => false  
# page "/robots.txt", :layout => false  

# activate :directory_indexes
# page "/google491a2a3f09d30d76.html", :directory_index => false

### 
# Compass
###
# Change Compass configuration
compass_config do |config|
  config.output_style = :compact
end

###
# Helpers
###
# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

module Helpers
  def gist(id, filename=nil)
    "<script src=\"https://gist.github.com/#{id}.js#{'?file=' + filename if filename}\"></script>"
  end
  def tag_articles(tag)
    blog.articles.select do |article|
      article.tags.include?(tag)
    end
  end
  def toc
    return '' unless current_article.respond_to?(:source_file)

    body = File.read(current_article.source_file, encoding: Encoding::UTF_8)
    markdown = body.gsub(/^---.*---/m, "") # remove Frontmatter
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC, filter_html: false)
    '<div class="toc">' + html_toc.render(markdown) + '</div>'
  end
  def article_description
    return '' unless current_article.respond_to?(:source_file)

    body = File.read(current_article.source_file, encoding: Encoding::UTF_8)
    markdown = body.gsub(/^---.*---/m, "") # remove Frontmatter
    markdown[0..120]
  end
  def amzn(asin)
    tag = <<"EOT"
<iframe
  src="http://rcm-fe.amazon-adsystem.com/e/cm?lt1=_blank&bc1=000000&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=#{data.site.amazon_id}&o=9&p=8&l=as4&m=amazon&f=ifr&ref=ss_til&asins=#{asin}"
  style="width:120px;height:240px;float:left;margin:10px 20px 10px 10px;"
  scrolling="no"
  marginwidth="0"
  marginheight="0"
  frameborder="0">
</iframe>
EOT
    tag
  end
  def first_day
    Time.parse(data.site.first_day.to_s).to_datetime
  end
  def years_from_first(date)
    date.year - first_day.year
  end
  def weeks_from_first(date)
    years_from_first(date) * 53 + date.cweek - first_day.cweek + 1
  end
  def days_from_first(date)
    (date - first_day).to_i + 1
  end
end
helpers Helpers

set :layouts_dir, '_layouts'
set :partials_dir, '_partials'

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

set :markdown_engine, :redcarpet

set( :markdown,
     :no_intra_emphasis   => true,
     :tables              => true,
     :fenced_code_blocks  => true,
     :autolink            => true,
     :strikethrough       => true,
     :lax_html_blocks     => true,
     :space_after_headers => true,
     :superscript         => true,
     :smartypants         => true,
     :with_toc_data       => true
     )

###
# Env-specific configuration
###
configure :development do
  activate :livereload
  set :debug_assets, true
end

configure :build do
  set :sass, style: :compact, line_comments: false
end

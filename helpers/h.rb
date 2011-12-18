helpers do
  def h(html)
    Rack::Utils.escape_html html
  end
end

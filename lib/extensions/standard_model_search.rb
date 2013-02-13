module StandardModelSearch
  
  def search(options, page = 1, per_page = PER_PAGE)
    term = options[:term]
    query = '(upper(name) like upper(:term) or upper(description) like upper(:term))'
    query_params = {:term => (term.blank? ? "" : "%#{term}%")}
    paginate :per_page => per_page, :page => page,
                      :conditions => [query, query_params]
  end
  
end
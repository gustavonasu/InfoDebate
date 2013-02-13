module StandardModelSearch
  
  def search(options, page = 1, per_page = PER_PAGE)
    query = ""
    query_params = {}
    
    if options[:term]
      build_query_by_term options[:term]  do |q, p|
        query = append_query(query, q)
        query_params.merge!(p)
      end
    end
    
    build_query_by_status options[:status]  do |q, p|
      query = append_query(query, q)
      query_params.merge!(p)
    end
    
    paginate :per_page => per_page, :page => page,
                      :conditions => [query, query_params]
  end
  
  def append_query(query, new_clause)
    new_query = query
    new_query += " and " unless query.blank?
    new_query += new_clause
  end
  
  def build_query_by_term(term)
    q = '(upper(name) like upper(:term) or upper(description) like upper(:term))'
    p = {:term => (term.blank? ? "" : "%#{term}%")}
    yield q, p
  end
  
  def build_query_by_status(status)
    status = :active if status.nil?
    q = '(status = :status)'
    p = {:status => ModelStatus::STATUS[status.to_sym]}
    yield q, p
  end
end
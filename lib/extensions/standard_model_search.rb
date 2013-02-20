module StandardModelSearch
  
  def search_by_name(name, page = 1, per_page = PER_PAGE)
    s = name.blank? ? "" : "%#{name}%"
    paginate :per_page => per_page, :page => page,
             :conditions => ['upper(name) like upper(?)', s]
  end
  
  
  def search(options, page = 1, per_page = PER_PAGE)
    query = ""
    query_params = {}
    
    if(self.respond_to?(:extended_search))
      result = extended_search(options)
      query, query_params = result unless result.nil?
    end
    
    unless options[:term].blank?
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

  
  private
  
    def append_query(query, new_clause)
      new_query = query
      new_query += " and " unless query.blank?
      new_query += new_clause
    end
  
    def build_query_by_term(term)
      q = create_query_for_term
      p = {:term => (term.blank? ? "" : "%#{term}%")}
      yield q, p
    end
    
    def create_query_for_term
      query = ""
        term_search_fields.each_with_index do |field, index|
        query += "upper(#{field}) like upper(:term)"
        query += " or " if term_search_fields.length - 1 > index
      end
      "(#{query})"
    end
    
  
    def build_query_by_status(status)
      status = :active if status.blank?
      q = '(status = :status)'
      p = {:status => find_status_value(status)}
      yield q, p
    end
end
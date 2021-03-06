module Search
  module StandardModelSearch
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      class String < ::String
        def append_query(new_clause)
          self.concat " and " if !self.blank? && !new_clause.blank?
          self.concat new_clause
        end
      end
      
      def def_default_search_fields(default_fields)
        define_singleton_method :default_search_fields do
          default_fields
        end
        
        define_singleton_method :create_default_query_by_term do |term|
          query = ""
          params = {}
          default_fields.keys.each_with_index do |field, index|
            if default_fields[field] == :integer
              query += "#{table_name}.#{field} = :#{field}"
              params[field] = term
            elsif default_fields[field] == :string
              query += "upper(#{table_name}.#{field}) like upper(:#{field})"
              params[field] = "%#{term}%"
            end
            query += " or " if default_fields.length - 1 > index
          end
          return "(#{query})", params
        end
      end
      
      def def_default_status_for_search(default_status)
        define_singleton_method :default_status_for_search do
          default_status
        end
      end
      
      def def_extended_search(&block)
        define_singleton_method :extended_search do |options|
          block.call(options)
        end
      end
      
      # Default joins is empty
      def joins_for_search; [] end
      
      def def_joins_for_search(*joins)
        define_singleton_method :joins_for_search do
          joins
        end
      end
      
      def search_by_name(name, page = 1, per_page = PER_PAGE)
        s = name.blank? ? "" : "%#{name}%"
        paginate :per_page => per_page, :page => page,
                 :conditions => ["upper(#{table_name}.name) like upper(?)", s]
      end
      
      def search(options, page = 1, per_page = PER_PAGE)
        query = String.new
        query_params = {}
        
        unless options[:term].blank?
          q, qp = create_default_query_by_term options[:term]
          query.append_query q
          query_params.merge! qp
        end
        
        if options[:status] != :all
          query.append_query "(#{table_name}.status = :status)"
          query_params.merge!({:status => find_status_for_search(options)})
        end
        
        if(self.respond_to?(:extended_search))
          q, qp = create_extended_search(options)
          query.append_query q
          query_params.merge! qp
        end
        paginate :per_page => per_page, :page => page, :joins => joins_for_search,
                 :conditions => [query, query_params]
      end
      
      def find_status_for_search(options)
        status = default_status_for_search
        status = options[:status] unless options[:status].blank?
        find_status_value(status)
      end
      
      def create_extended_search(options)
        query = String.new
        query_params = {}
        items = extended_search(options)
        unless items.nil?
          items.each do |new_entry|
            query.append_query "(#{new_entry[:query]})"
            query_params.merge! new_entry[:params]
          end
        end
        [query, query_params]
      end
    end
  end
end
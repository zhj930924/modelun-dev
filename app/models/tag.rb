class Tag < ActiveRecord::Base
    has_many :directives_tags
    has_many :directives, through: :directives_tags
    
    filterrific(
        default_filter_params: { sorted_by: 'created_at_desc' },
        available_filters: [
            :sorted_by,
            :search_query,
            :with_country_id,
            :with_created_at_gte
        ]
    )
    
    scope :sorted_by, lambda { |sort_option|
      # extract the sort direction from the param value.
      direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
      case sort_option.to_s
      when /^created_at_/
        # Simple sort on the created_at column.
        # Make sure to include the table name to avoid ambiguous column names.
        # Joining on other tables is quite common in Filterrific, and almost
        # every ActiveRecord table has a 'created_at' column.
        order("@tag.directives.created_at #{ direction }")
      when /^title_/
        # Simple sort on the name colums
        order("LOWER(@tag.directives.title) #{ direction }")
      when /^type_/
        # This sorts by a student's country name, so we need to include
        # the country. We can't use JOIN since not all students might have
        # a country.
        order("LOWER(@tag.directives.type) #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
      end
    }


    def self.options_for_select
      order('LOWER(tag)').map { |e| [e.tag, e.id] }
    end
    
end
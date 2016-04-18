class DirectivesTag < ActiveRecord::Base
    belongs_to :directive, :foreign_key => :directive_id
    belongs_to :tag, :foreign_key => :tag_id
    
    filterrific(
        default_filter_params: { sorted_by: 'created_at_desc' },
        available_filters: [
            :sorted_by,
            :search_query,
            :with_country_id,
            :with_created_at_gte
        ]
    )
# define ActiveRecord scopes for
# :search_query, :sorted_by, :with_country_id, and :with_created_at_gte
end
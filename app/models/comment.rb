class Comment < ActiveRecord::Base
    belongs_to :directive
    validates :content, presence: true, length: { maximum: 1000}
    validates :function, presence: true
    has_closure_tree order: 'created_at DESC'
    
    def to_graph_label
        title
    end

# define ActiveRecord scopes for
# :search_query, :sorted_by, :with_country_id, and :with_created_at_gte
end

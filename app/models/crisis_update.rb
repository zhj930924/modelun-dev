class CrisisUpdate < Directive
    has_many :update_crises, :foreign_key => :directive_id
    has_many :crises, through: :update_crises
end
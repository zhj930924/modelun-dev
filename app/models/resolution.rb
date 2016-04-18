class Resolution < Directive
    has_many :sponsorships, class_name: "ResolutionSponsorship",
                            foreign_key: "directive_id"
                            
    has_many :sponsors, through: :sponsorships, 
                        class_name: "Delegate",
                        source: :delegate
                        
    
    has_many :signatures, class_name: "ResolutionSigning",
                            foreign_key: "directive_id"
                            
    has_many :signers, through: :signatures, 
                        class_name: "Delegate",
                        source: :delegate
                        
    has_many :creations, class_name: "ResolutionCreation",
                            foreign_key: "directive_id"

    has_many :creators, through: :creations, 
                        class_name: "Delegate",
                        source: :delegate

    has_many :requests, class_name: "ResolutionRequest",
             foreign_key: "directive_id"

    has_many :requestors, through: :requests,
             class_name: "Delegate",
             source: :delegate
                        
end

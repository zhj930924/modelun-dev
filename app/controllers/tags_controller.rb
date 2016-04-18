class TagsController < ApplicationController
    before_action :authenticate_user!
    def index
        @filterrific = initialize_filterrific(
            Tag,
            params[:filterrific]
        ) or return
        @tags = @filterrific.find.page(params[:page])
    
        respond_to do |format|
            format.html
            format.js
        end
    end
    
    
    def new
        @directive = Directive.find_by(id: params[:directive_id])
        @tag = @directive.tags.build
        @relationship = DirectivesTag.new(directive_id: params[:directive_id])

    end
    
    def create
        directive = Directive.find_by(id: params[:tag][:directive_id])
        if directive.tags.create(tag: params[:tag][:tag])
            flash[:success] = "Tag Created!"
            type = directive.type
            if type == "Resolution"
                redirect_to public_resolutions_path
            elsif type == "PersonalDirective"
                redirect_to personal_directives_path
            elsif type == "CrisisUpdate"
                redirect_to crisis_updates_path
            elsif type == "Note"
                redirect_to notes_path
            else
              redirect_to root_url
            end
        else
            flash[:error] = "Tag Creation Failed"
            redirect_to root_url
        end
    end

    def destroy
        directive = Directive.find_by(id: params[:tag][:directive_id])
        Tag.find_by(tag:params[:tag][:tag])
    end
end
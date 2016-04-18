class DirectivesTagsController < ApplicationController
  before_action :authenticate_user!
  def create
    directive = Directive.find_by(id: params[:directive_id])
    tag_id = Tag.find_by(tag: params[:directives_tag][:tag]).id
    if directive.directives_tags.create(directive_id: params[:directive_id], 
                                        tag_id: tag_id)
      flash[:success] = "Link created!"
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
      flash[:error] = "Fail"
      render 'personal_directives/personal_directives'
    end
  end
  
  def destroy
    directive = Directive.find_by(id: params[:directive_id])
    if directive.directives_tags.find_by(tag_id: params[:directives_tag][:tag_id]).destroy
      flash[:success] = "Tags deleted"
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
      flash[:error] = "Tag deletion failed"
      redirect_to request.referrer
    end

  end
  
  def index
    @filterrific = initialize_filterrific(
      DirectivesTag,
      params[:filterrific]
    ) or return
    @directivestags = @filterrific.find.page(params[:page])
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  private
    def directive_params
      params.require(:directive).permit(:content, :picture, :title, :type)
    end
    
    def correct_user
      @directive = current_user.directives.find_by(id: params[:id])
      redirect_to root_url if @directive.nil?
    end
    
    
end
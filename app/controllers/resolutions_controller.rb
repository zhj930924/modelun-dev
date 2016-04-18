class ResolutionsController < DirectivesController
  before_action :authenticate_user!
  def new
    @resolution = current_user.created_resolutions.build
  end

  def create
    resolution = current_user.created_resolutions.build(type: params[:resolution][:type],
                                                       content: params[:resolution][:content],
                                                       title: params[:resolution][:title])
    if resolution.save
      flash[:success] = "Resolutions/Committee Directives Created!"
      resolution.creations.create(user_id: current_user[:id])

      if params[:resolution][:sponsors] != nil
        params[:resolution][:sponsors].each do |sponsor|
          resolution.sponsorships.create(user_id: sponsor)
        end
      end

      if params[:resolution][:signers] != nil
        params[:resolution][:signers].each do |signer|
          resolution.signatures.create(user_id: signer)
        end
      end
      redirect_to private_resolutions_path
    else
      flash[:error] = "Fail"
      @resolution = resolution
      render "resolutions/new"
    end


  end

  def update
    @directive = Directive.find_by(id: params[:id])
    if @directive.update_attributes(directive_params)
      redirect_to root_url
    else
      flash[:error] = "Wrong"
    end
  end

  def public_resolutions

    committee_users = "SELECT users.id FROM users WHERE users.committee = :committee"
    relevant_directives = "SELECT directive_id FROM directives_users WHERE user_id in (#{committee_users})"
    relevant_tags = "SELECT tag_id FROM directives_tags WHERE directive_id in (#{relevant_directives})"
    tags = Tag.where("tags.id in (#{relevant_tags})",committee: current_user.committee)

    comments = Resolution.with_comments
    @filterrific = initialize_filterrific(
        Directive,
        params[:filterrific],
        select_options: {
            with_tag_name: tags.options_for_select,
            with_user: Delegate.where(committee: current_user.committee).options_for_select,
            with_directive_status: ["On The Floor", "Draft", "Passed!", "Failed!"]
        }
    ) or return
    filter_result = @filterrific.find

    if user_signed_in?
      @user = current_user
      if current_user[:type] == "Delegate"
        resolutions_ids = "SELECT directive_id FROM directives_users
                                  WHERE user_id = :user_id"
        sql_result = Resolution.with_committees(current_user.committee).where("public = 't'")
        @resolution = current_user.created_resolutions.build

      elsif current_user[:type] == "Crisis"
        user_ids = "SELECT users.id FROM users WHERE committee = :committee"
        committee_directive_ids = "SELECT directive_id FROM directives_users
                        WHERE user_id IN (#{user_ids}) AND type IN ('ResolutionSponsorship',
                        'ResolutionSigning', 'ResolutionCreation')"
        sql_result = Resolution.with_committees(current_user.committee).where("directives.id IN (#{committee_directive_ids}) AND public = 't'",
                                    committee: current_user[:committee])

      end

      if params[:reply]
        @rs_feed = ((filter_result & sql_result) - comments).paginate(page: params[:rs_page], per_page: 5)
      else
        @rs_feed = (filter_result & sql_result).paginate(page: params[:rs_page], per_page: 5)
      end

    else redirect_to root_url
    end
  end

  def private_resolutions
    if user_signed_in?
      @user = current_user
      if current_user[:type] == "Delegate"
        resolutions_ids = "SELECT directive_id FROM directives_users
                                  WHERE user_id = :user_id AND type != 'ResolutionRequest'"
        @rs_feed = Resolution.with_committees(current_user.committee).distinct.where("directives.id IN (#{resolutions_ids} and public = 'f')",
                                    user_id: current_user[:id]).paginate(page: params[:rs_page], per_page: 5)
        @resolution = current_user.created_resolutions.build
      end
    else redirect_to root_url
    end
  end

  def resolution_management
    @sponsorship = current_user.sponsorships.new
    @signature = current_user.signatures.new
  end


  private
      def directive_params
          params.require(:resolution).permit(:content, :picture, :title, :type, :editable, :passed, :status, :public)
      end
end
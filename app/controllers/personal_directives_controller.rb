class PersonalDirectivesController < DirectivesController
  before_action :authenticate_user!
  def new
    @personal_directives = current_user.personal_directives.build
  end

  def create
      pd = current_user.personal_directives.build(content: params[:personal_directive][:content],
                                              title: params[:personal_directive][:title])
      if pd.save
        if params[:other_authors]
          params[:other_authors].each do |person|
            IssueDirective.create(user_id: person, directive_id: pd.id)
          end
        end
        flash[:success] = "Directive created!"
        current_user.issue_directives.create(directive_id: pd.id)
        redirect_to personal_directives_path
      else
        flash[:error] = "Fail"
        redirect_to request.referrer
      end

  end
  
  def update
    if current_user[:type] == "Delegate" or current_user.admin == true
      @directive = PersonalDirective.find_by(id: params[:id])
      @directive.update_attributes(directive_params)
      redirect_to personal_directives_path
    else
      flash[:error] = "Not editable"
      redirect_to request.referrer
    end
  end
  
  def edit
    @directive = PersonalDirective.find_by(id: params[:id])
  end

  def index

    committee_users = "SELECT users.id FROM users WHERE users.committee = :committee"
    relevant_directives = "SELECT directive_id FROM directives_users WHERE user_id in (#{committee_users})"
    relevant_tags = "SELECT tag_id FROM directives_tags WHERE directive_id in (#{relevant_directives})"
    tags = Tag.where("tags.id in (#{relevant_tags})",committee: current_user.committee)
    if user_signed_in?
      @filterrific = initialize_filterrific(
          PersonalDirective,
          params[:filterrific],
          select_options: {
              with_tag_name: tags.options_for_select,
              with_user: Delegate.where(committee: current_user.committee).options_for_select,
          }
      ) or return
      filter_result = @filterrific.find

      comments = PersonalDirective.with_comments



      if current_user[:type] == "Delegate"
        personal_directive_ids = "SELECT directive_id FROM directives_users
                          WHERE user_id = :user_id AND type = 'IssueDirective'"
        sql_result = PersonalDirective.with_committees(current_user.committee).where("directives.id IN (#{personal_directive_ids})",
                                             user_id: current_user[:id])

        @directive = current_user.directives.build(type: "PersonalDirective")

      elsif current_user[:type] == "Crisis"
        user_ids = "SELECT users.id FROM users WHERE committee = :committee"
        personal_directive_ids = "SELECT directive_id FROM directives_users
                          WHERE user_id IN (#{user_ids}) AND type = 'IssueDirective'"
        sql_result = PersonalDirective.with_committees(current_user.committee).where("directives.id IN (#{personal_directive_ids})",
                                             committee: current_user[:committee])

      end

      @pd_feed = sql_result & filter_result
      if params[:reply]
        @pd_feed = (@pd_feed - comments).paginate(page: params[:pd_page], per_page: 10)
      else
        @pd_feed = @pd_feed.paginate(page: params[:pd_page], per_page: 10)
      end


    else redirect_to root_url
    end
  end

  private
    def directive_params
      params.require(:personal_directive).permit(:content, :picture, :title, :type, :status, :editable, :quality, :claim)
    end
end
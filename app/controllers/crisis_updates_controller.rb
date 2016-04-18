class CrisisUpdatesController < DirectivesController
  before_action :authenticate_user!
  def new
    @crisis_update = current_user.crisis_updates.build
  end

  def create
    if current_user.crisis_updates.create(type: params[:crisis_update][:type],
                                          content: params[:crisis_update][:content],
                                          title: params[:crisis_update][:title])
      flash[:success] = "Crisis Updates Created!"
      redirect_to crisis_updates_path
    else
      flash[:error] = "Fail"
      redirect_to request.referrer
    end
  end

  def update
    @directive = Directive.find_by(id: params[:id])
    if @directive.update_attributes(directive_params)
      redirect_to crisis_updates_path
    else
      flash[:error] = "Wrong"
      redirect_to request.referrer
    end
  end

  def crisis_updates
    if user_signed_in?
      if current_user.type == "Delegate"
        @cs_feed = CrisisUpdate.with_committees(current_user.committee).with_public(true).paginate(page: params[:cs_page], per_page: 5)

      elsif current_user[:type] == "Crisis"
        @directive = current_user.crisis_updates.build
        @cs_feed = CrisisUpdate.with_committees(current_user.committee).paginate(page: params[:cs_page], per_page: 5)
      end
    else redirect_to root_url
    end
  end

  private
    def directive_params
      params.require(:crisis_update).permit(:content, :picture, :title, :type, :passed, :public, :status, :editable, :claim, :quality)
    end
end
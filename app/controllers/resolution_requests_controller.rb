class ResolutionRequestsController < ApplicationController
  before_action :authenticate_user!
  def create

    if current_user.requests.create(directive_id: params[:directive_id])
      redirect_to request.referrer
    else
      flash[:error] = "Relationship Not Created"
      redirect_to request.referrer
    end

    # respond_to do |format|
    #   format.html { redirect_to request.referrer}
    #   format.js {render inline: "location.reload();" }
    # end
  end

  def destroy
    if current_user.requests.find_by(directive_id: params[:directive_id]).destroy
      redirect_to request.referrer
    else
      flash[:error] = "Relationship Not Destroied"
      redirect_to request.referrer
    end
    # respond_to do |format|
    #   format.html { redirect_to "redirect_to :back"}
    #   format.js {render inline: "location.reload();" }
    # end
  end

end
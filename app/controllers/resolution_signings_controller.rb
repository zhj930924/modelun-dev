class ResolutionSigningsController < ApplicationController
    before_action :authenticate_user!
    def create
        directive = Directive.find_by(id:params[:directive_id])
        if params[:resolution_signing]
            ResolutionSigning.create(directive_id: params[:directive_id], user_id: params[:resolution_signing][:user_id])
            redirect_to request.referrer
        elsif !directive.creators.include?(current_user)
            if current_user.signatures.create(directive_id: params[:directive_id])
                redirect_to request.referrer
            else
                flash[:error] = "Relationship Not Created"
                redirect_to request.referrer
            end
        else
          redirect_to request.referrer
        end

        # respond_to do |format|
        #     format.html { redirect_to request.referrer}
        #     format.js
        # end
    end
    
    def destroy
        if params[:resolution_signing]
            ResolutionSigning.find_by(directive_id: params[:directive_id], user_id: params[:resolution_signing][:user_id]).destroy
            redirect_to request.referrer
        else
            if current_user.signatures.find_by(directive_id: params[:directive_id]).destroy
                redirect_to request.referrer
            else
                flash[:error] = "Relationship Not Removed"
                redirect_to request.referrer
            end
        end
        #
        # respond_to do |format|
        #     format.html { redirect_to request.referrer}
        #     format.js
        # end
    end

end
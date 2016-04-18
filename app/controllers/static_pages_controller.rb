class StaticPagesController < ApplicationController
  
  def home
    if user_signed_in?
      if current_user[:type] == "Crisis"
        user_ids = "SELECT users.id FROM users WHERE committee = :committee"
        personal_directive_ids = "SELECT directive_id FROM directives_users 
                        WHERE user_id IN (#{user_ids}) AND type = 'IssueDirective'"
        committee_directive_ids = "SELECT directive_id FROM directives_users 
                        WHERE user_id IN (#{user_ids}) AND type IN ('ResolutionSponsorship', 
                        'ResolutionSigning', 'ResolutionCreation')"
        @pd_feed = PersonalDirective.where("id in (#{personal_directive_ids})", 
                                            committee: current_user[:committee]).paginate(page: params[:pd_page], per_page: 10)
        @rs_feed = Resolution.with_public(true).where("id in (#{committee_directive_ids})",
                                        committee: current_user[:committee]).paginate(page: params[:rs_page], per_page: 5)
        
      elsif current_user[:type] == "Delegate"
        @cs_feed = CrisisUpdate.with_committees(current_user.committee).with_public(true).paginate(page: params[:cs_page], per_page: 5)
        committee_directive_ids = "SELECT directive_id FROM directives_users
                                  WHERE user_id = :user_id"
        @pd_feed = PersonalDirective.with_committees(current_user.committee).where("directives.id IN (#{committee_directive_ids})",
                                      user_id: current_user[:id]).paginate(page: params[:pd_page], per_page: 10)
      end
      
      @directive = current_user.directives.build
      
    end
  end

  def notes
    if user_signed_in?
      @user = current_user
      if  current_user[:type] == "Delegate"
        redirect_to root_url
      elsif(current_user[:type] == "Crisis")
        @directive = current_user.notes.build if user_signed_in?
        @note_feed = Note.with_committees(current_user.committee).paginate(page: params[:note_page])
      end
    else redirect_to root_url
    end
  end

  def maps
  end

  def download
    file = params[:file_name]
    send_file(file)
  end

end

class NotesController < DirectivesController
  before_action :authenticate_user!
  def create
    if current_user.notes.create(type: params[:note][:type], 
                                          content: params[:note][:content],
                                          title: params[:note][:title])
      flash[:success] = "Crisis Note Created!"
      redirect_to notes_path
    else
      flash[:error] = "Fail"
      render 'static_pages/notes'
    end
  end
    
  private 
    def directive_params
      params.require(:notes).permit(:content, :picture, :title, :type)
    end
end
module ApplicationHelper

  def full_title(page_title = "")
    base_title = "Emodelun"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
    
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-success"
      when :info then "alert alert-info"
      when :alert then "alert alert-danger"
      when :warning then "alert alert-warning"
    end
  end

  def active_page(active_page)
    @active == active_page ? "active" : ""
  end
    
  def display_date(date, message='Date unavailable')
  date ? l(date, format: :short) : message
  end

end

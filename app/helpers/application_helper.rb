module ApplicationHelper

  def full_title(title)
    base_title = "Scheduler"
    if title.nil?
      base_title
    else
      base_title + " | #{title}"
    end
  end
end

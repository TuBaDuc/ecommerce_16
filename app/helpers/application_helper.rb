module ApplicationHelper
  def full_title page_title = ""
    system_name = t(:system_name)
    if page_title.empty?
      system_name
    else
      page_title + " | " + system_name
    end
  end

  def set_index_number counter, page, limit
    (page - 1) * limit + counter + 1
  end
end

module ItemCommandsHelper
  def item_edit_command(url_options, html_options = nil)
    link_to 'Edit', url_options, prep_html_options(html_options)
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Edit", class:"glyphicon glyphicon-edit" }
    #end
  end
  def item_show_command(url_options, html_options = nil)
    link_to 'Show', url_options, prep_html_options(html_options)
  end
  def item_delete_command(url_options, html_options = nil)
    link_to 'Delete', url_options, prep_html_options(html_options)
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Delete", class:"glyphicon glyphicon-remove" }
    #end
  end
private
  def prep_html_options(html_options)
    html_options
    #if (html_options.nil?)
    #  html_options = { class: "btn btn-default btn-sm" }
    #  html_options
    #else
    #  html_options.merge class: "btn btn-default btn-sm"
    #end
  end
end

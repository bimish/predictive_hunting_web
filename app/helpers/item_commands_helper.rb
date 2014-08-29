module ItemCommandsHelper
  def item_edit_command(url_options, html_options = { })
    item_command 'Edit', url_options, html_options
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Edit", class:"glyphicon glyphicon-edit" }
    #end
  end
  def item_show_command(url_options, html_options = { })
    item_command 'Show', url_options, html_options
  end
  def item_delete_command(url_options, html_options = { })
    item_command 'Delete', url_options, html_options
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Delete", class:"glyphicon glyphicon-remove" }
    #end
  end
  def item_command(label, url_options, html_options = { })
    link_to label, url_options, prep_html_options(html_options)
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Delete", class:"glyphicon glyphicon-remove" }
    #end
  end
private
  def prep_html_options(html_options = { })
    html_options.merge class: "btn btn-default btn-sm"
  end
end

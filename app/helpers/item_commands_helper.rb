module ItemCommandsHelper
  def item_edit_command(url_options, html_options = { })
    #item_command 'Edit', url_options, html_options
    item_command_glyphicon 'Edit', 'edit', url_options, html_options
  end
  def item_show_command(url_options, html_options = { })
    item_command 'Show', url_options, html_options
  end
  def item_delete_command(url_options, html_options = { })
    #item_command 'Delete', url_options, html_options
    item_command_glyphicon 'Delete', 'remove', url_options, html_options
  end
  def item_command(label, url_options, html_options = { })
    link_to label, url_options, prep_html_options(label, html_options)
    #link_to url_options, prep_html_options(html_options) do |link|
    #  content_tag :span, '', { title: "Delete", class:"glyphicon glyphicon-remove" }
    #end
  end
  def item_command_glyphicon(label, glyphicon_name, url_options, html_options = { })
    link_to url_options, prep_html_options(label, html_options) do |link|
      content_tag :span, '', { class:"glyphicon glyphicon-#{glyphicon_name}" }
    end
  end
private
  def prep_html_options(title, html_options = { })
    html_options.merge( { title: title, class: "btn btn-default btn-sm" } )
  end
end

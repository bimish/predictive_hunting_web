module BootstrapHelper
  def bootstrap_glyphicon(name, options = { })
    class_names = options[:class]
    if class_names.blank?
      options[:class] = "glyphicon glyphicon-#{name}"
    else
      options[:class] = "glyphicon glyphicon-#{name} #{class_names}"
    end
    content_tag(:span, '', options)
  end
end

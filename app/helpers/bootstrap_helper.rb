module BootstrapHelper
  def bootstrap_glyphicon(name)
    tag(:span, class: "glyphicon glyphicon-#{name}")
  end
end

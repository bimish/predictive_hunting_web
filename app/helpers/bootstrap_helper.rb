require 'app/will_paginate_bootstrap'

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
  def will_paginate_bootstrap(collection = nil, options = {})
    options[:renderer] = WillPaginateBootstrap::BootstrapLinkRenderer
    will_paginate collection, options
  end
end

require 'app/exceptions'
module Web
  class Application
    ActionView::Base.default_form_builder = ApplicationHelper::AppFormBuilder
    config.autoload_paths += %W(#{config.root}/lib/app)
    config.autoload_paths += %W(#{config.root}/app/presenters)
  end
end

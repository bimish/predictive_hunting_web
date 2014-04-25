module Web
  class Application
    ActionView::Base.default_form_builder = ApplicationHelper::AppFormBuilder
  end
end
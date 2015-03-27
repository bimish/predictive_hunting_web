class ComponentController < ApplicationController

  define_callbacks :initialize_new_instance

  before_action :check_signed_in_user
  before_action :prepare_for_action

  def get_component
    raise Exceptions::MustBeOverridden, 'get_component must be overridden in the controller'
  end

  def new_component(params = nil)
    raise Exceptions::MustBeOverridden, 'new_component must be overridden in the controller'
  end

  def create_params
    raise Exceptions::MustBeOverridden, 'create_params must be overridden in the controller'
  end

  def authorize_action
    unless @component.nil?
      raise Exceptions::NotAuthorized unless @component.authorize_action?(current_user, crud_action)
    end
  end

  def self.after_initialize_new_instance(*args, &block)
    set_callback :initialize_new_instance, :after, *args, &block
  end

  def self.before_initialize_new_instance(*args, &block)
    set_callback :initialize_new_instance, :before, *args, &block
  end

  # this can be overridden in controllers to allow actions without an authenticted user
  def action_requires_authenticated_user
    true
  end

private

  def prepare_for_action

    case crud_action

      when :create
        run_callbacks :initialize_new_instance do
          if (action_name == 'new')
            @component = new_component()
          else
            @component = new_component(create_params)
          end
          @component.init_new current_user
        end

      when :read, :update, :delete
        @component = get_component

    end

    authorize_action

  end

  def check_signed_in_user
    if action_requires_authenticated_user
      ensure_signed_in
    end
  end

  def crud_action
    @crud_action ||= get_crud_action
  end

  def get_crud_action
    case action_name
    when 'new', 'create'
      :create
    when 'show'
      :read
    when 'edit', 'update'
      :update
    when 'delete', 'destroy'
      :delete
    when 'index', 'search'
      :search
    else
      :other
    end
  end

end

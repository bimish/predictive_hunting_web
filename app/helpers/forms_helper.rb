module FormsHelper

  def _check_box(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.check_box instance_method, options
  end
  def _color_field(form, instance_method, label, options = {})
    form.color_field instance_method
  end
  def _date_field(form, instance_method, label, options = {})
    form.date_field instance_method
  end
  def _datetime_field(form, instance_method, label, options = {})
    form.datetime_field instance_method, options
  end
  def _datetime_local_field(form, instance_method, label, options = {})
    form.datetime_local_field instance_method, options
  end
  def _datetime_select(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    if (options[:ampm].blank?)
      options[:ampm] = true
    end
    if (options[:default].blank?)
      options[:default] = Time.zone.now - 1
    end
    form.datetime_select instance_method, options
  end
  def _email_field(form, instance_method, label, options = {})
    form.email_field instance_method, options
  end
  def _file_field(form, instance_method, label, options = {})
    form.file_field instance_method, options
  end
  def _hidden_field(form, instance_method, label, options = {})
    form.hidden_field instance_method, options
  end
  def _month_field(form, instance_method, label, options = {})
    form.month_field instance_method, options
  end
  def _number_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.number_field instance_method, options
  end
  def _password_field(form, instance_method, label, options = {})
    form.password_field instance_method
  end
  def _phone_field(form, instance_method, label, options = {})
    form.phone_field instance_method
  end
  def _radio_button(form, instance_method, label, options = {})
    form.radio_button instance_method
  end
  def _range_field(form, instance_method, label, options = {})
    form.range_field instance_method
  end
  def _search_field(form, instance_method, label, options = {})
    form.search_field instance_method
  end
  def _select_field(form, instance_method, label, choices, options = {}, html_options = {})
    if (!label.nil?)
      options[:label] = label
      options[:include_blank] ="[#{label}]"
    end
    form.select instance_method, choices, options, html_options
  end
  def _telephone_field(form, instance_method, label, options = {})
    form.telephone_field instance_method
  end
  def _text_area_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    options[:rows] = 5
    form.text_area instance_method, options
  end
  def _text_field(form, instance_method, label, max_length = 255, options = {})
    if (max_length > 255)
      _text_area(form, instance_method, label, options)
    else
      if (!label.nil?)
        options[:label] = label
      end
      options[:max_length] = max_length
      form.text_field instance_method, options
    end
  end
  def _time_field(form, instance_method, label, options = {})
    form.time_field instance_method
  end
  def _url_field(form, instance_method, label, options = {})
    form.url_field instance_method
  end
  def _week_field(form, instance_method, label, options = {})
    form.week_field instance_method
  end

  def _submit_button(form, instance_record, title, options = {})
    options[:class] = 'btn btn-default btn-primary btn-sm'
    form.submit instance_record.nil? ? 'Search' : instance_record.new_record? ? 'Create' : 'Update', options
  end

  def _check_box_list(form, title, options = {}, &block)
    raise ArgumentError, "Missing block" unless block_given?
    content_tag(:div, class:'form-group') do
      check_box_list_builder = CheckBoxListBuilder.new(form)
      label_tag(nil, title, class:'control-label') +
      content_tag(:div, class:'input-group') do
        yield check_box_list_builder
      end
    end
  end

  class CheckBoxListBuilder
    def initialize(form)
      @form = form
    end
    def add_item(instance_method, label, options = {})
      if (!label.nil?)
        options[:label] = label
      end
      @form.check_box instance_method, options
    end
  end

end

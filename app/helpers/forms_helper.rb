module FormsHelper

  def _check_box(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.check_box instance_method, options
  end
  def _color_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.color_field instance_method, options
  end
  def _date_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.date_field instance_method, options.merge({ size: 15, style:'width:auto;' })
  end
  def _date_picker(form, instance_method, label, options = {})
    field_value = date_to_s(form.object.send(instance_method), :rfc3339)
    group_options = { class:'form-group date-picker-form-group' }
    if options.has_key?(:date_format)
      group_options = group_options.merge({ data: { date_format: options[:date_format] } })
    end
    picker_field_options = { class:'form-control date-picker' }
    if options.has_key?(:picker_width)
      picker_field_options = picker_field_options.merge({ size: options[:picker_width] })
    end
    content_tag(:div, group_options) do
      combine_tags(
        label_tag(nil, label, class:'control-label'),
        text_field_tag("#{instance_method}_picker", nil, picker_field_options ),
        date_field_tag("#{form.object_name}[#{instance_method}]", field_value, { class:'form-control' } )
      )
    end
  end

  def _date_select(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.date_select instance_method, options
  end
  def _datetime_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.datetime_field instance_method, options
  end
  def _datetime_local_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
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
    if (!label.nil?)
      options[:label] = label
    end
    form.email_field instance_method, options
  end
  def _file_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.file_field instance_method, options
  end
  def _hidden_field(form, instance_method, label, options = {})
    form.hidden_field instance_method, options
  end
  def _month_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.month_field instance_method, options
  end
  def _number_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.number_field instance_method, options
  end
  def _password_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.password_field instance_method, options
  end
  def _phone_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.phone_field instance_method, options
  end
  def _radio_button(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.radio_button instance_method, options
  end
  def _range_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.range_field instance_method, options
  end
  def _search_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.search_field instance_method, options
  end
  def _select_field(form, instance_method, label, choices, options = {}, html_options = {})
    if (!label.nil?)
      options[:label] = label
      options[:include_blank] ="[#{label}]"
    end
    form.select instance_method, choices, options, html_options
  end
  def _static_control(form, instance_method, label, content = nil, options = {})
    if (instance_method.nil?)
      form.static_control(nil, label: label) do
        content
      end
    else
      if (!label.nil?)
        options[:label] = label
      end
      form.static_control instance_method, content, options
    end
  end
  def _telephone_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.telephone_field instance_method, options
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
      _text_area_field(form, instance_method, label, options)
    else
      if (!label.nil?)
        options[:label] = label
      end
      options[:max_length] = max_length
      form.text_field instance_method, options
    end
  end
  def _time_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.time_field instance_method, options
  end
  def _time_select(form, instance_method, label, options = {}, html_options = {})
    selected_value = form.object.send(instance_method)
    unless selected_value.nil?
      selected_value = time_to_s(selected_value, :rfc3339)
    end
    _select_field form, instance_method, label, options_for_select(hour_of_day_select_options, selected_value), options, html_options
  end
  def _url_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.url_field instance_method, options
  end
  def _week_field(form, instance_method, label, options = {})
    if (!label.nil?)
      options[:label] = label
    end
    form.week_field instance_method, options
  end

  def _submit_button(form, instance_record, title = nil, options = {})
    options[:class] = 'btn btn-default btn-primary btn-sm'
    if title.nil?
      title = instance_record.nil? ? 'Search' : instance_record.new_record? ? 'Create' : 'Update'
    end
    form.submit title, options
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

  def _radio_button_list(form, instance_method, title, options = {}, &block)
    raise ArgumentError, "Missing block" unless block_given?
    content_tag(:div, class:'form-group') do
      radio_button_list_builder = RadioButtonListBuilder.new(form, instance_method)
      label_tag(nil, title, class:'control-label') +
      content_tag(:div, class:'input-group') do
        yield radio_button_list_builder
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

  class RadioButtonListBuilder
    def initialize(form, instance_method)
      @form = form
      @field_instance_method = instance_method
    end
    def add_item(instance_method, label, value, options = {})
      if (!label.nil?)
        options[:label] = label
      end
      options[:name] = "#{@form.object_name}[#{@field_instance_method}]"
      @form.radio_button instance_method, value, options
    end
  end

end

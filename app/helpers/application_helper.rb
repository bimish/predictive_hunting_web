module ApplicationHelper

  include DataDomains

  def full_page_title(page_title)
    base_title = "Predictive Hunting"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}".html_safe
    end
  end

  def date_time_to_s(date_time_value, format = :short)
    date_to_s(date_time_value, format) + " " + time_to_s(date_time_value, format)
  end

  def date_to_s(date_time_value, format = :short)
    if date_time_value.nil?
      nil
    else
      localize date_time_value.to_date, format: format
    end
  end

  def time_to_s(date_time_value, format = :short)
    if date_time_value.nil?
      nil
    else
      localize date_time_value.in_time_zone, format: format
    end
  end

  def date_time_to_feed(date_time_value)
    time_ago_in_words date_time_value
    # today = Date.today
    # value_date = date_time_value.to_date
    # difference = Date.current - value_date
    # if (difference) < 1
    #   "Today at " + value_date_as_local.strftime("%I:%M %p")
    # elsif (difference) < 2
    #   "Yesterday at " + value_date_as_local.strftime("%I:%M %p")
    # elsif (today.year == value_date_as_local.year)
    #   value_date_as_local.strftime("%B %d %I:%M %p")
    # else
    #   value_date_as_local.strftime("%B %d %Y %I:%M %p")
    # end
  end

  def gravatar_for(user, options = { size: 40 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://www.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt:user.alias, class: "gravatar")
  end

  def combine_tags(*tags)
    capture do
      tags.each do |tag|
        concat tag
      end
    end
  end

  def popup_dialog(title, options = {}, &block)

    raise ArgumentError, "Missing block" unless block_given?

    if options[:class].blank?
      options[:class] = 'popup-dialog'
    else
      options[:class] << ' popup-dialog'
    end
    data_options = { role: 'popup', dismissible:'false'}
    if (options[:data].blank?)
      options[:data] = data_options
    else
      options[:data] = options[:data].merge(data_options)
    end

    content_tag(:div, options) do
      content_tag(:div, class: 'popup-header') do
        content_tag(:h1, title) +
        link_to('Close', '#', { class: 'ui-btn ui-corner-all ui-icon-delete ui-btn-icon-notext', data: { rel:'back'} })
      end +
      content_tag(:div, class: 'popup-content') do
        yield
      end
    end
  end

  def hour_of_day_select_options
    @@hour_of_day_select_options ||= (1..24).collect do |hour|
      time = Date.current + hour.hours
      [ time_to_s(time, :short), time_to_s(time, :rfc3339)]
    end
    @@hour_of_day_select_options
  end

  class AppFormBuilder < ActionView::Helpers::FormBuilder

    def coordinates_field(method, options = {})
      options[:readonly] = 'true'
      options[:value] = @object.send(method)
      @template.text_field(@object_name, method, objectify_options(options))
    end

  end

  # method to create a presenter class from the view
  def present(model, klass = nil)
    klass ||= "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end

  module ModelHelpers

  end

end

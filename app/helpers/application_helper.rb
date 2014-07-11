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

  def date_time_to_s(date_time_value, include_year = false)
    if include_year
      date_time_value.utc.getlocal.strftime("%m/%d/%Y %I:%M %p")
    else
      date_time_value.utc.getlocal.strftime("%B %d %I:%M %p")
    end
  end

  def date_time_to_feed(date_time_value)
    today = Date.today
    value_date_as_local = date_time_value.utc.getlocal
    value_date = value_date_as_local.to_date
    difference = Date.today - value_date
    if (difference) < 1
      "Today at " + value_date_as_local.strftime("%I:%M %p")
    elsif (difference) < 2
      "Yesterday at " + value_date_as_local.strftime("%I:%M %p")
    elsif (today.year == value_date_as_local.year)
      value_date_as_local.strftime("%B %d %I:%M %p")
    else
      value_date_as_local.strftime("%B %d %Y %I:%M %p")
    end
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

  class AppFormBuilder < ActionView::Helpers::FormBuilder

    def coordinates_field(method, options = {})
      options[:readonly] = 'true'
      options[:value] = @object.send(method)
      @template.text_field(@object_name, method, objectify_options(options))
    end

  end

  module ModelHelpers

  end

end

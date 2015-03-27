require 'will_paginate/view_helpers/action_view'

module WillPaginateBootstrap

  class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer

    protected

    def html_container(html)
      tag(:ul, html, container_attributes)
    end

    def page_number(page)
      link_options = { :rel => rel_value(page) }
      if @options[:remote]
        link_options = link_options.merge({ 'data-remote' => 'true' })
      end
      tag :li, link(page, page, link_options), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      link_options = { }
      if @options[:remote]
        link_options = link_options.merge({ 'data-remote' => 'true' })
      end
      tag :li, link(text, page || '#', link_options), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end

    def url(page)
      super(page)
    end

  end

end


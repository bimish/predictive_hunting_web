module MapHelper

  class MapHelperUtils
    include ActionView::Helpers::JavaScriptHelper
  end

  Modes = {
    'View' => 'MapsHelper.Mode.View',
    'SetLocation' => 'MapsHelper.Mode.SetLocation',
    'SetBoundary' => 'MapsHelper.Mode.SetBoundary'
  }

  @@utils = MapHelperUtils.new
  def self.create_map_helper_script(hunting_plot, canvas_id, options = {})

    if options.key?(:function_name)
      script = "function #{options[:function_name]}() {\n"
    elsif options.key?(:variable_name)
      script = "var #{options[:variable_name]} = function () {\n"
    else
      raise ArgumentError, 'Either a function name or variable name must be provided'
    end

    escaped_name = @@utils.escape_javascript(hunting_plot.name)
    script << "var mapOptions = { markerTitle: '#{escaped_name}' };\n"

    if !hunting_plot.boundary.nil?
      view_window = RgeoHelper.get_bounds(hunting_plot.boundary)
      script << "mapOptions.view_window = { sw: { lat: #{view_window[:sw][:lat]}, lng: #{view_window[:sw][:lng]} }, ne: { lat: #{view_window[:ne][:lat]}, lng: #{view_window[:ne][:lng]} } };\n"
    else
      script << "mapOptions.zoom = 12;\n"
    end

    script << "mapOptions.center = { lat: #{hunting_plot.location_coordinates.y()}, lng: #{hunting_plot.location_coordinates.x()} };\n"

    unless hunting_plot.boundary.nil?
      script << "mapOptions.boundary = parseWKTPolygon('#{hunting_plot.boundary.to_s}');\n"
    end

    if options.key?(:mode)
      script << "mapOptions.mode = #{options[:mode]};\n"
    end

    script << "return new MapsHelper($('##{canvas_id}').get(0), mapOptions);\n"

    if options.key?(:function_name)
      script << "}\n"
    elsif options.key?(:variable_name)
      script << "}();\n"
    end

    script

  end

end

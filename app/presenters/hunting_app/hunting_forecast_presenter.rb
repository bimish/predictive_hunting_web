module HuntingApp

  class HuntingForecastPresenter < BasePresenter

    attr_reader :minor_am_time_span, :minor_pm_time_span, :major_am_time_span, :major_pm_time_span

    def initialize(model, view)
      super
      @minor_am_time_span = create_time_span self.minor_am, 1.hours
      @minor_pm_time_span = create_time_span self.minor_pm, 1.hours
      @major_am_time_span = create_time_span self.major_am, 2.hours
      @major_pm_time_span = create_time_span self.major_pm, 2.hours
    end

    def has_day_overlap?
      @has_day_overlap
    end

    private

    def create_time_span(time, span_size)
      if time.nil?
        time_span = '-'
      else
        start_time = time - (span_size / 2)
        end_time = time + (span_size / 2)
        time_format = :hours_minutes
        is_previous_day = false
        is_next_day = false
        if (start_time.day < end_time.day)
          is_previous_day = true
          @has_day_overlap = true
        elsif (start_time.day > end_time.day)
          is_next_day = true
          @has_day_overlap = true
        end
        time_span = h.time_to_s(start_time, :short) + (is_previous_day ? '*' : '') + ' - ' + h.time_to_s(end_time, :short) + (is_next_day ? '*' : '')
      end
      time_span
    end

  end

end

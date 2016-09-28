#This is a wrapper around time_diff gem
class TimeDifference

  class TimeHashOverload

    def initialize(start_at, end_at)
      @start_at = start_at
      @end_at = end_at
    end

    def in_hours
      h = Time.diff(@start_at, @end_at, '%h.%m')
      h[:diff]
    end

    def in_hrs_mins_secs
      h = Time.diff(@start_at, @end_at, '%h.%m.%s')
      h[:diff]
    end

  end

  class <<self

    def between(start_at, end_at)

      start_at = DateTime.parse(start_at) if start_at.is_a?(String)

      end_at = DateTime.parse(end_at) if end_at.is_a?(String)

      TimeHashOverload.new(start_at, end_at)

    end

  end

end
require "Time"

def time_diff($start, $end)
    t = Time.at( Time.parse($start) - Time.parse($end) )
    (t - t.gmt_offset).strftime("%H:%M:%S.%L")
end
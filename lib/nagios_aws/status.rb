require "stringio"
module Nagios
  module Status
    class << self
      def critical? options, stats
        if options.critical
         return true if stats.first > options.critical.to_f
        end
      end

      def warning? options, stats
        if options.warning
          return true if stats.first  > options.warning.to_f
        end
      end

      def get options, stats
        return Nagios::CRITICAL if critical? options, stats
        return Nagios::WARNING if warning? options, stats
        return Nagios::OK
      end

      def information statistics, options
        status = get(options, statistics)
        statistics = statistics.map do |stat| 
          "#{stat}#{Nagios::UNITS[options.unit.downcase.to_sym]}"
        end
        [StringIO.new("Metric #{options.metric} #{status}: #{statistics.join(', ')}"), status]
      end
    end
  end
end

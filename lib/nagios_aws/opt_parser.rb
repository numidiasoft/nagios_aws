require "ostruct"
require "time"
require 'optparse'

module Nagios
  module OptParser
    class << self
       def parse args
         options = OpenStruct.new
         options.metric = "CurrConnections"
         options.namespace = "AWS/ElastiCache"
         options.criteria = "Maximum"
         options.unit = "Count"
         options.verbose = false
         options.dimension_name = "CacheClusterId"
         options.dimension_value = "identifier"

         OptionParser.new do |opts|
           opts.banner = "Usage: cloud_watch.rb [options]"
           opts.on( "-v", "--verbose", "Output more information: Default => #{options.verbose}" ) do 
             options[:verbose] = true
           end

           opts.on("-h", "--help", "Show this message") do |value|
             puts opts
             exit
           end

           opts.on("-m", "--metric", "Choose the metric to get : Default => #{options.metric}") do
             options.metric = ARGV.first
           end

           opts.on("-n", "--namespace", "Choose the namespace to get: Default = #{options.namespace}, possible values #{NAMESPACES.join(', ')}") do
             options.namespace = ARGV.first
           end

           opts.on("-u", "--unit", "Choose the unit to use : Default => #{options.unit}") do
             options.unit = ARGV.first
           end

           opts.on("-a", "--criteria", "Choose the criteria to use : Default => #{options.criteria}") do
             options.criteria = ARGV.first
           end

           opts.on("-d", "--dimension_name", "Choose the dimension name to use : Default => #{options.dimension_name}") do
             options.dimension_name = ARGV.first
           end

           opts.on("-i", "--dimension_value", "Choose the dimension value (the identifier) to use : Default => #{options.dimension_value}") do
             options.dimension_value = ARGV.first
           end

           opts.on("-w", "--warning", "Choose the warning threshold") do
             options.warning = ARGV.first
           end

           opts.on("-c", "--critical", "Choose the critical threshold") do
             options.critical = ARGV.first
           end
         end.parse! and return options
       end
    end
  end
end

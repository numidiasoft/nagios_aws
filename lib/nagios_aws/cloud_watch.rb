require "rubygems"
require "aws-sdk-v1"

module Nagios
  module CloudWatch

    class << self
      attr_accessor :config_file_path

      def init
        config = load_aws_file
        AWS.config(access_key_id: config.AWS_ACCESS_KEY_ID, secret_access_key: config.AWS_SECRET_ACCESS_KEY, region: config.AWS_REGION)
      end

      def load_aws_file
        begin
          config = OpenStruct.new(YAML.load_file(config_file_path))
        rescue
          raise "Puts the config file aws.yml ander #{File.expand_path(config_file_path)} directory"
        end
      end

      def stats options
        metric = AWS::CloudWatch::Metric.new(
          options.namespace,
          options.metric,
          dimensions: [ { :name => options.dimension_name, :value => options.dimension_value } ]
        )

        stats = metric.statistics(
          start_time: Time.now - 360,
          end_time:  Time.now,
          statistics: [options.criteria],
          unit: options.unit
        )
      end

      def format_stats stats, options
        datapoints = stats.datapoints.each do |datapoint|
          datapoint[:timestamp] = datapoint[:timestamp].to_i
        end

        datapoints = datapoints.sort_by { |a| a[:timestamp] }.reverse[0..2]
        datapoints.map do |metrics|
          metrics[options.criteria.downcase.to_sym]
        end
      end
    end
  end
end
  

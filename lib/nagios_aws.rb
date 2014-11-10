
require_relative "nagios_aws/opt_parser"
require_relative "nagios_aws/cloud_watch"
require_relative "nagios_aws/status"
require_relative "nagios_aws/version"

module Nagios
  NAMESPACES = %w( AWS/EC2 AWS/ElastiCache AWS/EBS AWS/RDS AWS/SNS AWS/ELB)
  UNITS =  { percent: "%" }
  OK = "OK"
  WARNING = "WARNING"
  CRITICAL = "CRITICAL"
  STATUS_CODES = {
    OK: 0,
    WARNING: 1,
    CRITICAL: 2,
    UNKNOWN: 3 
  }

  class << self
    def cloud_watch
      options = Nagios::OptParser.parse(ARGV) 
      Nagios::CloudWatch.config_file_path = "/etc/aws.yml"
      Nagios::CloudWatch.init
      stats = Nagios::CloudWatch.stats(options)
      formated_stats = Nagios::CloudWatch.format_stats(stats, options)
      description, status = Nagios::Status.information(formated_stats, options)
      puts description.string
      exit(STATUS_CODES[status.to_sym])
    end
  end
end

require_relative "../spec_helper"


describe Nagios::CloudWatch do
  let(:true_config_file) { "spec/fixtures/config/aws.yml" }
  let(:false_config_file) { "aws.yml" }
  let(:options) {
    options = OpenStruct.new
    options.metric = "CurrConnections"
    options.namespace = "AWS/ElastiCache"
    options.criteria = "Maximum"
    options.unit = "Count"
    options.verbose = false
    options.dimension_name = "CacheClusterId"
    options.dimension_value = "sleekapp"
    options
  }

  describe "#load_aws_file" do

    context "When file exists" do
      it "loads the config file" do
        described_class.config_file_path = true_config_file
        config = described_class.load_aws_file
        expect(config.class).to be(OpenStruct)
        expect(config.AWS_ACCESS_KEY_ID).not_to be(nil)
        expect(config.AWS_SECRET_ACCESS_KEY).not_to be(nil)
        expect(config.AWS_REGION).not_to be(nil)
      end
    end

    context "When file doesn't exists" do
      it "raises load file error" do
        expect{ 
          described_class.config_file_path = false_config_file
          described_class.load_aws_file
        }.to raise_error
      end
    end
  end

  describe "#init" do
    it "init AWS config" do
      described_class.config_file_path = true_config_file
      aws = described_class.init
      expect(aws.class).to be(AWS::Core::Configuration)
    end
  end

  describe "#stats" do
    context "Elasticache stats" do
      it "return current connections status" do
        VCR.use_cassette('Elasticache') do
          described_class.config_file_path = true_config_file 
          described_class.init
          stats = described_class.stats options
          expect(stats.class).to be(AWS::CloudWatch::MetricStatistics)
          expect(stats.datapoints).not_to be_empty
        end
      end
    end
  end

  describe "#stats" do
    context "Elasticache stats" do
      it "return current connections status" do
        VCR.use_cassette('Elasticache') do
          described_class.config_file_path = true_config_file 
          described_class.init
          stats = described_class.stats options
          formated_stats = described_class.format_stats stats, options
          expect(formated_stats.class).to be(Array)
          expect(formated_stats.size).to be(3)
        end
      end
    end
  end

end


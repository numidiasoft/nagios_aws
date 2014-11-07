require_relative "../spec_helper"

describe Nagios::Status do
  let(:options) { OpenStruct.new }

  describe "#critical?" do
    context "When true" do
      it "returns critical true" do
        stats = [80, 20.5, 10.99]
        options.critical = 40
        status = described_class.critical? options, stats
        expect(status).to be(true)
      end
    end

    context "When false" do
      it "returns critical false" do
        stats = [80, 20.5, 10.99]
        options.critical = 90
        status = described_class.critical? options, stats
        expect(status).to be(nil)
      end
    end
  end

  describe "#warning?" do
    context "When true" do
      it "returns warning true" do
        stats = [80, 20.5, 10.99]
        options.warning = 40
        status = described_class.warning? options, stats
        expect(status).to be(true)
      end
    end

    context "When false" do
      it "returns warning false" do
        stats = [80, 20.5, 10.99]
        options.warning = 90
        status = described_class.warning? options, stats
        expect(status).to be(nil)
      end
    end
  end

  describe "#get" do
    it "return a status" do
      stats = [80, 20.5, 10.99]
      options.warning = 40
      status = described_class.get options, stats
      puts status
      included = [Nagios::CRITICAL, Nagios::WARNING, Nagios::OK].include?(status)
      expect(included).to be(true)
    end
  end

  describe "#information" do
    it "returns a nagios formatted status" do
      stats = [80, 20.5, 10.99]
      options.warning = 40
      options.unit = "percent"
      nagios_status = described_class.information stats, options
      expected_response = "Metric  WARNING: 80%, 20.5%, 10.99%"
      expect(nagios_status.string).to eql(expected_response)
    end
  end

end


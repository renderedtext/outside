require 'spec_helper'

describe Outside do

  subject { Outside::Options }

  describe ".timeout_duration" do
    it "returns the set timeout" do
      return_value = subject.timeout_duration([])

      expect(return_value).to eql(5)
    end

    context "custom timeout" do
      it "returns the custom timeout" do
        timeout = 10

        return_value = subject.timeout_duration([{:timeout => timeout}])

        expect(return_value).to eql(timeout)
      end
    end
  end

  describe ".handle_timeout?" do
    context "handle it" do
      it "returns true" do
        return_value = subject.handle_timeout?([:handle_timeout])

        expect(return_value).to be true
      end
    end

    context "don't handle it" do
      it "returns false" do
        return_value = subject.handle_timeout?([])

        expect(return_value).to be false
      end
    end
  end

end

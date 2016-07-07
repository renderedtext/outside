require 'spec_helper'

describe Outside do

  subject { Outside::Options }

  describe ".duration" do
    it "returns the set timeout duration" do
      return_value = subject.duration([])

      expect(return_value).to eql(5)
    end

    context "custom timeout" do
      it "returns the custom timeout duration" do
        timeout = 10

        return_value = subject.duration([{:duration => timeout}])

        expect(return_value).to eql(timeout)
      end
    end
  end

  describe ".handle?" do
    context "handle it" do
      it "returns true" do
        return_value = subject.handle?([:handle])

        expect(return_value).to be true
      end
    end

    context "don't handle it" do
      it "returns false" do
        return_value = subject.handle?([])

        expect(return_value).to be false
      end
    end
  end

end

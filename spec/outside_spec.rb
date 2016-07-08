require 'spec_helper'

describe Outside do

  it 'has a version number' do
    expect(Outside::VERSION).not_to be nil
  end

  describe ".go" do
    it "returns the output" do
      expect(Outside.go { 5 }).to eql 5
    end

    context "total limit" do
      context "default" do
        it "sets the default total limit" do
          expect(Timeout).to receive(:timeout).with(3600)

          Outside.go
        end
      end

      context "custom" do
        it "sets the default total limit" do
          limit = 100

          expect(Timeout).to receive(:timeout).with(100)

          Outside.go({ :total_limit => limit })
        end
      end
    end

    context "handle timeout exception" do
      context "handle it" do
        it "handles it" do
          allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)

          expect(Outside.go({ :handle_timeout => true })).to be nil
        end
      end

      context "don't handle it" do
        it "doesn't handle it" do
          allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)

          expect{ Outside.go }.to raise_error(Timeout::Error)
        end
      end
    end
  end

end

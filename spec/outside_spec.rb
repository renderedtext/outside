require 'spec_helper'

describe Outside do

  subject { Outside }

  it 'has a version number' do
    expect(Outside::VERSION).not_to be nil
  end

  describe ".go" do
    it "wraps the yield in a timeout block" do
      expect(Timeout).to receive(:timeout).with(5)

      Outside.go
    end

    context "custom timeout" do
      it "wraps the yield in a timeout block" do
        timeout = 10

        expect(Timeout).to receive(:timeout).with(timeout)

        Outside.go({:duration => timeout})
      end
    end

    context "timeout" do
      it "raises the timeout error" do
        expect { Outside.go({ :duration => 0.2 }) { sleep 0.5 } }.to raise_error(Timeout::Error)
      end
    end

    context "exception handling enabled" do
      it "handles the timeout error" do
        expect { Outside.go(:handle, { :duration => 0.2 }) { sleep 0.5 } }.not_to raise_error
      end
    end
  end

end

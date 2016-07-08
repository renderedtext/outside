require 'spec_helper'

describe Outside do

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

    context "retry" do
      before do
        allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)
      end

      context "retry count is default" do
        it "does not retry" do
          expect(Timeout).to receive(:timeout).exactly(1).times

          Outside.go(:handle, { :retry_count => 0 })
        end
      end

      context "retry count set above 0" do
        it "retries n times" do
          n = 3

          expect(Timeout).to receive(:timeout).exactly(n + 1).times

          Outside.go(:handle, { :retry_count => n })
        end
      end

      context "retry interval is default" do
        it "does not sleep" do
          expect_any_instance_of(Outside::Execution).to receive(:sleep).with(0)

          Outside.go(:handle, { :retry_count => 1 })
        end
      end

      context "retry interval set above 0" do
        it "sleeps n seconds between retries" do
          interval = 1

          expect_any_instance_of(Outside::Execution).to receive(:sleep).with(1)

          Outside.go(:handle, { :retry_count => 1 }, { :retry_interval => 1})
        end
      end
    end
  end

end

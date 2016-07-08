require 'spec_helper'

describe Outside::Execution do

  describe "#run" do
    it "wraps the yield in a timeout block" do
      expect(Timeout).to receive(:timeout).with(5)

      described_class.new.run
    end

    context "return value" do
      context "successful execution" do
        it "returns the value of execution" do
          expect(described_class.new.run { 5 }).to eql(5)
        end
      end

      context "unsuccessful execution" do
        it "returns nil" do
          options = { :iteration_limit => 0.1, :handle_timeout => true }

          expect(described_class.new(options).run { sleep 1; 5 }).to be nil
        end
      end
    end

    context "custom timeout" do
      it "wraps the yield in a timeout block" do
        timeout = 10
        options = { :iteration_limit => timeout }

        expect(Timeout).to receive(:timeout).with(timeout)

        described_class.new(options).run
      end
    end

    context "timeout" do
      it "raises the timeout error" do
        options = { :iteration_limit => 0.2 }

        expect { described_class.new(options).run { sleep 0.5 } }.to raise_error(Timeout::Error)
      end
    end

    context "exception handling enabled" do
      it "handles the timeout error" do
        options = { :handle_timeout => true, :iteration_limit => 0.2 }

        expect { described_class.new(options).run { sleep 0.5 } }.not_to raise_error
      end
    end

    context "retry" do
      before do
        allow(Timeout).to receive(:timeout).and_raise(Timeout::Error)
      end

      context "retry count is default" do
        it "does not retry" do
          options = { :handle_timeout => true, :retry_count => 0 }

          expect(Timeout).to receive(:timeout).exactly(1).times

          described_class.new(options).run
        end
      end

      context "retry count set above 0" do
        it "retries n times" do
          n = 3
          options = { :handle_timeout => true, :retry_count => n }

          expect(Timeout).to receive(:timeout).exactly(n + 1).times

          described_class.new(options).run
        end
      end

      context "retry interval is default" do
        it "does not sleep" do
          options = { :handle_timeout => true, :retry_count => 1 }

          instance = described_class.new(options)

          expect(instance).to receive(:sleep).with(0)

          instance.run
        end
      end

      context "retry interval set above 0" do
        it "sleeps n seconds between retries" do
          interval = 1
          options = { :handle_timeout => true, :retry_count => 1, :interval_duration => interval }

          instance = described_class.new(options)

          expect(instance).to receive(:sleep).with(interval)

          instance.run
        end
      end

      context "retry with backoff" do
        it "retries with increasing interval" do
          options = {
            :retry_count => 2,
            :interval_duration => 1,
            :interval_increment => 1,
            :interval_factor => 1.5,
            :handle_timeout => true
          }

          instance = described_class.new(options)

          expect(instance).to receive(:sleep).with(1)
          expect(instance).to receive(:sleep).with(2.5)

          instance.run
        end

        context "max interval is reached" do
          it "caps the interval" do
            options = {
              :retry_count => 2,
              :interval_duration => 1,
              :interval_factor => 1.5,
              :interval_limit => 1.2,
              :handle_timeout => true
            }

            instance = described_class.new(options)

            expect(instance).to receive(:sleep).with(1)
            expect(instance).to receive(:sleep).with(1.2)

            instance.run
          end
        end

        context "random factor" do
          before do
            options = {
              :handle_timeout => true,
              :retry_count => 1,
              :interval_duration => 0.1,
              :interval_randomness => 0.2
            }

            @instance = described_class.new(options)
          end

          it "determines a random factor by which to multiply the interval" do
            expect(Random).to receive(:rand).with(0.8..1.2).and_return(1)

            @instance.run
          end

          it "multiplies the interval by a random factor" do
            expect(@instance).to receive(:sleep) do |duration|
              expect(duration).to be_within(0.02).of(0.1)
            end

            @instance.run
          end
        end
      end
    end
  end

end

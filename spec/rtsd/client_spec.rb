require 'spec_helper'

describe Rtsd::Client do
  subject { Rtsd::Client.new(:hostname => 'localhost', :port => 4242) }
  let(:socket) { double("Socket", :puts => nil) }

  before(:each) do
    TCPSocket.stub(:new).and_return(socket)
  end

  describe "#put" do
    let(:timestamp) { Time.now.to_i }
    let(:params) {{:metric => "cows.count",
                   :value => 42,
                   :timestamp => timestamp,
                   :tags => {:cats => 'meow', :foo => 'bar'}}}

    it "builds a tcp socket connection" do
      TCPSocket.should_receive(:new).with('localhost', 4242)
      subject.put(params)
    end

    it "puts the formatted data on the socket" do
      socket.should_receive(:puts).with("put cows.count #{timestamp} 42.0 cats=meow foo=bar")
      subject.put(params)
    end

    context 'missing keys' do
      it 'raises ArgumentError with no params' do
        expect{subject.put({})}.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError with missing metric' do
        expect{subject.put({:value => 1, :timestamp => Time.now.to_i, :tags => {:foo => 'bar'}})}.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError with missing value' do
        expect{subject.put({:metric => 1, :timestamp => Time.now.to_i, :tags => {:foo => 'bar'}})}.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError with missing tags' do
        expect{subject.put({:metric => 'foo.bar', :value => 1, :timestamp => Time.now.to_i})}.to raise_error(ArgumentError)
      end

      it 'does not raise ArgumentError with missing timestamp' do
        expect{subject.put({:metric => 'foo.bar', :value => 1, :tags => { :foo => 'bar' }})}.not_to raise_error()
      end
    end

    context "no server listening" do
      before(:each) do
        TCPSocket.stub(:new).and_raise(Errno::ECONNREFUSED)
      end

      it "does not raise" do
        expect {
          subject.put(params)
        }.to_not raise_error
      end
    end

    context "server goes away" do
      before(:each) do
        socket.stub(:puts).and_raise(Errno::EPIPE)
      end

      it "does not raise" do
        expect {
          subject.put(params)
        }.to_not raise_error
      end

      it "retries 3 times" do
        socket.should_receive(:puts).exactly(3).times
        subject.put(params)
      end

      context "server has really gone away" do
        before(:each) do
          @times = 0
          TCPSocket.stub(:new) do |h,p|
            @times += 1
            if @times == 1
              socket
            else
              raise Errno::ECONNREFUSED
            end
          end
        end

        it "does not retry 3 times" do
          socket.should_receive(:puts).exactly(1).times
          subject.put(params)
        end
      end
    end
  end
end

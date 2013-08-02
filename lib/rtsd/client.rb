module Rtsd
  class Client
    attr_reader :connection

    def initialize(options = {})
      @connection = Rtsd::Connection.new(options)
    end

    def put(params)
      metric    = params.fetch(:metric)
      timestamp = params[:timestamp] || Time.now.to_i
      value     = params.fetch(:value).to_f
      tags      = params.fetch(:tags).map{|k,v| "#{k}=#{v}"}.join(" ")
      connection.puts "put %s %d %s %s" % [metric, timestamp, value, tags]
    rescue KeyError => e
      raise ArgumentError, e.message
    end
  end
end

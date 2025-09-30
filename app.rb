require 'sinatra'
require 'json'
require 'time'

# Configure Sinatra
set :port, ENV['PORT'] || 4567
set :bind, '0.0.0.0'
set :environment, ENV['RACK_ENV'] || 'development'

# Main endpoint
get '/' do
  content_type :json

  {
    message: "Hello from Sample Ruby App! 💎",
    service: "sample-ruby-app",
    environment: ENV['RACK_ENV'] || 'development',
    runtime: {
      language: "Ruby",
      version: RUBY_VERSION,
      platform: RUBY_PLATFORM,
      engine: RUBY_ENGINE
    },
    timestamp: Time.now.utc.iso8601
  }.to_json
end

# Health check endpoint
get '/health' do
  content_type :json

  {
    status: "healthy",
    timestamp: Time.now.utc.iso8601,
    service: "sample-ruby-app",
    version: "1.0.0",
    runtime: {
      language: "Ruby",
      version: RUBY_VERSION,
      platform: RUBY_PLATFORM,
      engine: RUBY_ENGINE
    }
  }.to_json
end

# Metrics endpoint
get '/metrics' do
  content_type :json

  # Get process memory info (basic)
  memory_info = {}
  begin
    if File.exist?('/proc/self/status')
      status = File.read('/proc/self/status')
      if match = status.match(/VmRSS:\s+(\d+)\s+kB/)
        memory_info[:rss_kb] = match[1].to_i
        memory_info[:rss_mb] = (match[1].to_i / 1024.0).round(2)
      end
    end
  rescue
    memory_info[:error] = "Memory info not available"
  end

  {
    memory: memory_info,
    runtime: {
      ruby_version: RUBY_VERSION,
      ruby_engine: RUBY_ENGINE,
      platform: RUBY_PLATFORM,
      process_id: Process.pid,
      parent_process_id: Process.ppid
    },
    gc_stats: GC.stat,
    timestamp: Time.now.utc.iso8601
  }.to_json
end

# Error handling
error do
  content_type :json
  status 500

  {
    error: "Internal Server Error",
    message: env['sinatra.error'].message,
    timestamp: Time.now.utc.iso8601
  }.to_json
end

# 404 handler
not_found do
  content_type :json

  {
    error: "Not Found",
    message: "The requested endpoint does not exist",
    available_endpoints: ["/", "/health", "/metrics"],
    timestamp: Time.now.utc.iso8601
  }.to_json
end

# Startup message
if __FILE__ == $0
  puts "🚀 Sample Ruby App starting on port #{settings.port}"
  puts "📊 Health check: http://localhost:#{settings.port}/health"
  puts "📈 Metrics: http://localhost:#{settings.port}/metrics"
end

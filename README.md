# Sample Ruby App

A simple HTTP server built with Ruby and Sinatra for benchmarking and testing purposes.

## Features

- HTTP server with JSON responses using Sinatra
- Health check endpoint
- Runtime metrics endpoint with GC stats
- Environment-aware configuration
- Production-ready with Puma server

## Endpoints

- `GET /` - Main endpoint with service information
- `GET /health` - Health check endpoint
- `GET /metrics` - Runtime metrics (memory, GC stats, process info)

## Local Development

```bash
# Install dependencies
bundle install

# Run the application (development)
bundle exec ruby app.rb

# Or run with Puma (production-like)
bundle exec rackup -p 4567

# For auto-reloading during development
bundle exec rerun ruby app.rb
```

## Environment Variables

- `PORT` - Server port (default: 4567)
- `RACK_ENV` - Environment (development/production)

## Production Deployment

The app uses Puma as the production server and is configured via `config.ru` for Rack-compatible platforms.

```bash
# Production start command
bundle exec rackup -p $PORT -o 0.0.0.0
```

## Docker Support

```dockerfile
FROM ruby:3.2-alpine
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment --without development
COPY . .
EXPOSE 4567
CMD ["bundle", "exec", "rackup", "-p", "4567", "-o", "0.0.0.0"]
```

## Deployment

This app is designed to work with:
- DigitalOcean App Platform
- Heroku
- Railway
- Any Rack-compatible platform

The app automatically detects the PORT environment variable and binds to all interfaces (0.0.0.0).

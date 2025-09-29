# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rails
gem "bootsnap", require: false
gem "rails", "~> 8.1.0.beta1"

# Database
gem "pg", "~> 1.1"
gem "redis"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "paper_trail"

# Server
gem "puma", ">= 5.0"

# Support
gem "image_processing", "~> 1.2"
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Runtime
gem "bcrypt", "~> 3.1.7"
gem "sidekiq"
gem "sidekiq-unique-jobs"

# Services
gem "kaminari"
gem "ransack"
gem "rotp"
gem "rqrcode"
gem "view_component"

# Assets
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"

group :development do
  gem "annotaterb"
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
  gem "web-console"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "rspec-sidekiq"
end

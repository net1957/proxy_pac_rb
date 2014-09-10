source 'https://rubygems.org'

# Specify your gem's dependencies in local_pac.gemspec
gemspec

group :test do
  gem 'rspec', require: false
  gem 'fuubar', require: false
  gem 'simplecov', require: false
  gem 'rubocop', require: false
  gem 'coveralls', require: false
  gem 'cucumber', require: false
  gem 'aruba', require: false
end

group :development, :test do
  if !ENV.key?('CI') && !ENV.key?('TRAVIS')
    gem 'pry'
    gem 'pry-doc', require: false

    if RUBY_VERSION > '2.0.0'
      gem 'byebug'
      gem 'pry-byebug', require: false
    else
      gem 'debugger'
      gem 'pry-debugger'
    end
  end

  gem 'github-markup'
  gem 'redcarpet', require: false
  gem 'tmrb', require: false
  gem 'yard', require: false
  gem 'inch', require: false
  gem 'rake', require: false
  gem 'fedux_org-stdlib', '~>0.7.25', require: false
  gem 'bundler', '~> 1.3', require: false
  gem 'erubis'
  gem 'versionomy', require: false
  gem 'filegen'
  gem 'sinatra', require: 'sinatra/base'
  gem 'rack'
  gem 'activesupport', '~> 4.0.0', require: false
  gem 'awesome_print', require: 'ap'
end

group :profile do
  gem 'ruby-prof'
end

group :runtimes do
  group :therubyracer do
    gem 'therubyracer', require: 'v8'
  end

  group :therubyrhino do
    gem 'therubyrhino', require: 'rhino'
  end
end

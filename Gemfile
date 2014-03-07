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

group :development do
  gem 'debugger'
  gem 'debugger-completion'
  gem 'github-markup'
  gem 'pry'
  gem 'pry-debugger', require: false
  gem 'pry-doc', require: false
  gem 'redcarpet', require: false
  gem 'tmrb', require: false
  gem 'yard', require: false
  gem 'inch', require: false
end

group :profile do
  gem 'ruby-prof'
end

gem 'rake', group: [:development, :test], require: false
gem 'fedux_org-stdlib', group: [:development, :test], require: false
gem 'bundler', '~> 1.3', group: [:development, :test], require: false
gem 'erubis', group: [:development, :test]
gem 'versionomy', group: [:development, :test], require: false
gem 'activesupport', '~> 4.0.0', group: [:development, :test], require: false

gem 'awesome_print', group: [:development, :test], require: 'ap'

group :runtimes do
  group :therubyracer do
    gem 'therubyracer'
  end

  group :therubyrhino do
    gem 'therubyrhino'
  end
end

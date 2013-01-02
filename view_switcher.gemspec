# -*- encoding: utf-8 -*-
require File.expand_path('../lib/view_switcher/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matthew Nguyen"]
  gem.email         = ["contact@n-studio.fr"]
  gem.description   = %q{ViewSwitcher for RubyMotion}
  gem.summary       = %q{ViewSwitcher for RubyMotion}
  gem.homepage      = "https://github.com/n-studio/ViewSwitcher.git"
  
  gem.add_dependency 'bubble-wrap'
  gem.add_development_dependency 'rake'
  gem.files         = Dir['lib/**/*'] + Dir['motion/**/*'] + ['Gemfile', 'Rakefile', 'view_switcher.gemspec']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "view_switcher"
  gem.require_paths = ["lib"]
  gem.version       = BubbleWrap::ViewSwitcher::VERSION
end

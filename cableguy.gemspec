$:.push File.expand_path('../lib', __FILE__)
require 'palmade/cableguy/version'

Gem::Specification.new do |s|
  s.name        = 'cableguy'
  s.version     = ENV['BUILD_VERSION'] || Palmade::Cableguy::VERSION

  s.authors     = [ 'Next Level' ]
  s.email       = [ 'crew@nlevel.io' ]
  s.homepage    = 'https://github.com/nlevel/cableguy'

  s.summary     = %q{Generate configurations based on a template and a cabling database}
  s.description = %q{Generate configurations based on a template and a cabling database}
  s.rubyforge_project = 'cableguy'

  s.add_dependency 'sqlite3', '~> 1.3'
  s.add_dependency 'sequel', '~> 5.5'
  s.add_dependency 'thor', '~> 0.20'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = [ 'lib' ]
end

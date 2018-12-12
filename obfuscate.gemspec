# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "obfuscate/version"

Gem::Specification.new do |s|
  s.name          = %q{obfuscate}
  s.license       = "MIT"
  s.version       = Obfuscate::VERSION
  s.platform      = Gem::Platform::RUBY
  s.homepage      = %q{https://github.com/mguymon/obfuscate}
  s.authors       = ["Michael Guymon"]
  s.email         = ["mguymon@tobedevoured.com"]
  s.description   = %q{Obfuscate}
  s.summary       = %q{Obfuscate}

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency(%q<otherinbox-crypt19>, ["~> 1.2.1"])
  s.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
  s.add_development_dependency(%q<guard-rspec>, ["~> 2.4.0"])
  s.add_development_dependency(%q<rb-inotify>, ["~> 0.8.8"])
  s.add_development_dependency(%q<activerecord>, [">= 3.2.22.1"])
  s.add_development_dependency(%q<sqlite3>, ["~> 1.3.13"])
  s.add_development_dependency(%q<yard>, [">= 0.9.11"])
end
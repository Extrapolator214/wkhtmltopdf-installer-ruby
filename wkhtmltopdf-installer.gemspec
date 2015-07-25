require File.expand_path("../lib/wkhtmltopdf_installer/version.rb", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'wkhtmltopdf-installer'
  s.version     = WkhtmltopdfInstaller::GEM_VERSION
  s.summary     = 'Light-weight cross-platform (Linux and OSX) wkhtmltopdf binary installer'
  s.description = "Downloads wkhtmltopdf binary during 'Building native extension...' phase"
  s.authors     = ['Vladimir Yartsev']
  s.email       = 'vovayartsev@gmail.com'
  s.files       = Dir.glob ['ext/*.rb', 'ext/Makefile.*', 'lib/*.rb', 'lib/**/*.rb']
  s.extensions  = ['ext/extconf.rb']
  s.bindir      = 'bin'
  s.executables = %w(wkhtmltopdf)
  s.homepage    = 'http://rubygems.org/gems/wkhtmltopdf-installer'
  s.license     = 'MIT'
end

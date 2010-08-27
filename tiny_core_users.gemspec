Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "tiny_core_users"
  s.version   =   "0.0.1"
  s.date      =   Date.today.strftime('%Y-%m-%d')
  s.author    =   "Thomas Kadauke"
  s.email     =   "tkadauke@imedo.de"
  s.summary   =   "Simple reusable user management with generator based on authlogic"
  s.files     =   Dir.glob("{lib,rails_generators}/**/*")

  s.require_path = "lib"
end

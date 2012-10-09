# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "popthis"
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Lea"]
  s.date = "2012-10-09"
  s.description = "Run a pop server serving up the current dir."
  s.email = "commit@tomlea.co.uk"
  s.executables = ["popthis"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["Rakefile", "README.markdown", "lib/pop_this.rb", "bin/popthis"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Run a pop server serving up the current dir."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

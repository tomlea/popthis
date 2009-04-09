# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{popthis}
  s.version = "0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Lea"]
  s.date = %q{2009-04-10}
  s.description = %q{Run a pop server serving up the current dir.}
  s.email = %q{commit@tomlea.co.uk}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown", "Rakefile", "lib/pop_this.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Run a pop server serving up the current dir.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

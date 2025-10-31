# frozen_string_literal: true

require_relative "lib/cr/exec/version"

Gem::Specification.new do |spec|
  spec.name = "cr-exec"
  spec.version = Cr::Exec::VERSION
  spec.authors = ["initdc"]
  spec.email = ["initd@outlook.com"]

  spec.summary = "Wrapper for ruby exec"
  spec.description = "The improved exec lib inspired from Crystal"
  spec.homepage = "https://github.com/initdc/cr-exec"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/initdc/cr-exec.git"
  spec.metadata["changelog_uri"] = "https://github.com/initdc/cr-exec/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(/\Aexe\//) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

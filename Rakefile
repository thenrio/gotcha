require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gotcha"
    gem.summary = %Q{grabber for versatile source and layout}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "thierry.henrio@gmail.com"
    gem.homepage = "http://github.com/thierryhenrio/gotcha"
    gem.authors = ["thierryhenrio"]
    gem.add_development_dependency "rspec"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.rcov = true
  spec.rcov_opts = ['--no-rcovrt'] # rt coverage is broken with ruby-1.9.1-p376 and rcov-0.9.8
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gotcha #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# bluff dies with 3.0.0 activesupport
gem 'activesupport', '=2.3.5'
require 'metric_fu'
MetricFu::Configuration.run do |config|
  #define which metrics you want to use
  config.metrics  = [:flog, :flay, :roodi, :rcov]
  config.graphs   = [:flog, :flay, :roodi, :rcov]
  config.flay     = { :dirs_to_flay => ['lib'],
                      :minimum_score => 100  }
  config.flog     = { :dirs_to_flog => ['lib']  }
  config.roodi    = { :dirs_to_roodi => ['lib'] }
  config.rcov     = { :test_files => ['spec/**/*_spec.rb'],
                      :rcov_opts => ["--sort coverage",
                                     "--no-html",
                                     "--text-coverage",
                                     "--no-color",
                                     "--profile",
                                     '--no-rcovrt', # rt coverage is broken with ruby-1.9.1-p376 and rcov-0.9.8
                                     "--exclude /gems/,/Library/,spec"]}
  config.graph_engine = :bluff
end

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end
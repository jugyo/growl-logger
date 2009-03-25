$:.unshift File.dirname(__FILE__) + '/lib/'
require 'growl-logger'
require 'spec/rake/spectask'

desc 'run all specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-c']
end

desc 'Generate gemspec'
task :gemspec do |t|
  open('growl-logger.gemspec', "wb" ) do |file|
    file << <<-EOS
Gem::Specification.new do |s|
  s.name = 'growl-logger'
  s.version = '#{GrowlLogger::VERSION}'
  s.summary = "Logger using Growl."
  s.description = "Logger using Growl. You can output logs as growl notification so easily!"
  s.files = %w( #{Dir['lib/**/*.rb'].join(' ')}
                #{Dir['spec/**/*.rb'].join(' ')}
                #{Dir['examples/**/*.rb'].join(' ')}
                README.rdoc
                Rakefile )
  s.author = 'jugyo'
  s.email = 'jugyo.org@gmail.com'
  s.homepage = 'http://github.com/jugyo/growl-logger'
  s.rubyforge_project = 'growl-logger'
end
    EOS
  end
  puts "Generate gemspec"
end

desc 'Generate gem'
task :gem => :gemspec do |t|
  system 'gem', 'build', 'growl-logger.gemspec'
end

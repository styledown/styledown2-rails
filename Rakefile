require 'bundler'
task default: :test

Bundler::GemHelper.install_tasks

desc 'Runs tests'
task :test do
  # $:.unshift(File.expand_path(__FILE__, '../lib'))
  # Dir['test/**/*test.rb'].each { |fn| require_relative fn }
  system "cd example; bundle update --local; bundle exec rake test"
end

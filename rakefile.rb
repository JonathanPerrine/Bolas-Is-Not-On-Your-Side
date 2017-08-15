require 'rspec/core/rake_task'
require './lib/metered_cube'

task :default do
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task["spec"].execute
end

task :run_cube_metrics do
	ruby "lib/metered_cube.rb"
	@metered_cube = MeteredCube.new(File.expand_path("./decklist.txt"))
	puts @metered_cube.get_metrics_hash
end
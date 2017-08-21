require 'rspec/core/rake_task'
require './lib/metered_cube'

task :run_tests do
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task["spec"].execute
end

task :run_cube_metrics => :run_tests do
	ruby "lib/metered_cube.rb"
	@metered_cube = MeteredCube.new(File.expand_path("./decklist.txt"))
	@metered_cube.set_color_targets({"White" => 60, "Blue" => 60, "Black" => 60, "Red" => 60, "Green" => 60, "Gold" => 30, "Colorless" => 30})
	puts @metered_cube.display_cube_metrics
end

task :default => :run_cube_metrics
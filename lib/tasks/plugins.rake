namespace :plugins do
  desc "Updates the plugins database with the latest info from rubygems.org"
  task :update => :environment do
    PluginUpdater.new.update
  end
end


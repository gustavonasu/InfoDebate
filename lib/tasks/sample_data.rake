namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:populate_users'].invoke
    Rake::Task['db:populate_forums'].invoke
  end
end
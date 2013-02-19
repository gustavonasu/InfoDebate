namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:populate_users'].invoke
    Rake::Task['db:populate_forums'].invoke
    Rake::Task['db:populate_comments'].invoke
    Rake::Task['db:populate_complaints'].invoke
  end
end
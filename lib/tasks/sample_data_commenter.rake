namespace :db do
  desc "Fill database with sample data"
  task :populate_commenter => :environment do
    require 'faker'
    if Commenter.count == 0
      make_commenters
    end
  end
end

def make_commenters
  100.times do |n|
    name = Faker::Name.name
    username = "commenter-#{n+1}"
    email = "#{username}@infodebate.com"
    password = "password"
    Commenter.create!(:name => name,
                      :username => username,
                      :email => email,
                      :password => password,
                      :password_confirmation => password)
  end
end
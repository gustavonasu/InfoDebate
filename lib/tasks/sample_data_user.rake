namespace :db do
  desc "Fill database with sample data"
  task :populate_user => :environment do
    require 'faker'
    if User.count == 0
      make_users
    end
  end
end

def make_users
  100.times do |n|
    name = Faker::Name.name
    username = "user-#{n+1}"
    email = "#{username}@infodebate.com"
    password = "password"
    User.create!(:name => name,
                      :username => username,
                      :email => email,
                      :password => password,
                      :password_confirmation => password)
  end
end
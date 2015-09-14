namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task prepare: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    # 10.times { User.create!(email: Faker::Internet.email) }
    me = User.create(display_name: "Clay", gh_user_id: "claycarpenter")
    me.save

    puts "User id: #{me.id}"
    puts "All saved?"
  end
end

# Inspired by this post by SO user Agis:
# http://stackoverflow.com/a/24496452/1148628

namespace :db do
  desc 'Drop, create, migrate, seed and populate sample data'
  task prepare: [:drop, :create, :migrate, :seed, :populate_sample_data] do
    puts 'Ready to go!'
  end

  desc 'Populates the database with sample data'
  task populate_sample_data: :environment do
    # 10.times { User.create!(email: Faker::Internet.email) }
    me = User.create(
      display_name: "Clay Carpenter",
      gh_user_id: "claycarpenter",
      email: "claycarpenter@gmail.com",
      username: "claycarpenter")
    me.save

    5.times do |i|
      snippet = Snippet.create(
        title: "Snippet #{i}",
        code: "<p>Lorem ipsum #{i}</p>",
        expl_md: "This is the another snippet.",
        user: me
      )
      snippet.save
    end
  end
end

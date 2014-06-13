#require 'active_support'
#require 'active_support/core_ext/integer/time'

namespace :db do
  desc 'Populate database with sample data'
  task populate: :environment do
    make_users
    make_user_relationships
    make_animal_species
    make_animal_categories
    make_animal_activity_types
    make_hunting_plots
    make_hunting_locations
    make_hunting_plot_named_animals
    make_user_plot_accesses
    make_user_posts
  end
end

def make_users
  User.create!(first_name:'System', last_name:'Admin', :alias=>'System Admin', email:'mike.shutt@comcast.net', password:'password', password_confirmation:'password', authentication_method:1, admin:true)
  @mike_user = User.create(first_name:'Mike', last_name:'Shutt', :alias=>'Mike', email:'mjshutt@gmail.com', password:'password', password_confirmation:'password', authentication_method:1, admin:false)
  @todd_user = User.create(first_name:'Todd', last_name:'Moncrief', :alias=>'Todd', email:'mtmoncrief@gmail.com', password:'password', password_confirmation:'password', authentication_method:1, admin:false)
  @don_user = User.create(first_name:'Don', last_name:'Blaylock', :alias=>'Don', email:'donblaylock@glaciercnc.com', password:'password', password_confirmation:'password', authentication_method:1, admin:false)
  @other_users = Array.new
  10.times do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    @other_users.push User.create(first_name: first_name, last_name: last_name, :alias=> "#{first_name} #{last_name}", email:Faker::Internet.safe_email(first_name), password:'password', password_confirmation:'password', authentication_method:1, admin:false)
  end
end

def make_user_relationships
  @mike_user.relationships.create(related_user_id:@todd_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
  @mike_user.relationships.create(related_user_id:@don_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
  @todd_user.relationships.create(related_user_id:@mike_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
  @todd_user.relationships.create(related_user_id:@don_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
  @don_user.relationships.create(related_user_id:@todd_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
  @don_user.relationships.create(related_user_id:@mike_user.id, relationship_type:DataDomains::UserRelationshipType['Friend'])
end

def make_animal_species
  AnimalSpecies.create!(species: 'Odocoileus virginianus', common_name:'white-tailed deer')
  AnimalSpecies.create!(species: 'Odocoileus hemionus', common_name:'black-tailed deer (mule deer)')
end

def make_animal_categories
  AnimalCategory.create!(name:'Faun', animal_species_id: 1, gender:0, maturity:1, trophy_rating:0)
  AnimalCategory.create!(name:'Young Doe', animal_species_id: 1, gender:2, maturity:3, trophy_rating:0)
  AnimalCategory.create!(name:'Mature Doe', animal_species_id: 1, gender:2, maturity:5, trophy_rating:1)
  AnimalCategory.create!(name:'Young Buck', animal_species_id: 1, gender:1, maturity:2, trophy_rating:0)
  AnimalCategory.create!(name:'Medium Buck', animal_species_id: 1, gender:1, maturity:3, trophy_rating:1)
  @mature_buck_category = AnimalCategory.create(name:'Mature Buck', animal_species_id: 1, gender:1, maturity:4, trophy_rating:2)
  @trophy_buck_category = AnimalCategory.create(name:'Trophy Buck', animal_species_id: 1, gender:1, maturity:5, trophy_rating:3)
end

def make_animal_activity_types
  AnimalActivityType.create!(name: 'Walking')
  AnimalActivityType.create!(name: 'Feeding')
  AnimalActivityType.create!(name: 'Bedding')
  AnimalActivityType.create!(name: 'Chasing')
  AnimalActivityType.create!(name: 'Fighting')
  AnimalActivityType.create!(name: 'Sparring')
end

def make_hunting_plots
  @todds_plot = HuntingPlot.create(name:"Todd's Plot", location_coordinates: 'POINT (-82.6025 33.4458)', location_address: 'Warrenton, GA 30828, USA', boundary:'POLYGON ((-82.6056 33.4543, -82.608 33.4464, -82.6056 33.4447, -82.6064 33.443, -82.6065 33.4372, -82.5987 33.4305, -82.5962 33.4292, -82.5937 33.4288, -82.5958 33.4313, -82.6 33.4338, -82.6003 33.4379, -82.5969 33.447, -82.5933 33.4498, -82.598 33.4514, -82.6026 33.4537, -82.6056 33.4543))')
  @mikes_plot = HuntingPlot.create(name:"Northampton", location_coordinates: 'POINT (-84.4731 34.0328)', location_address: 'Marietta, GA 30066, USA', boundary:'POLYGON ((-84.4763 34.0415, -84.4768 34.0301, -84.4726 34.0307, -84.4686 34.0298, -84.4674 34.0311, -84.469 34.0324, -84.4688 34.0348, -84.467 34.037, -84.4697 34.0382, -84.4725 34.0412, -84.4763 34.0415))')
end

def make_hunting_locations
  @todds_plot.locations.create(name:'Paul\'s Ladder', coordinates:'POINT (-82.605943 33.440066)', location_type:1)
  @todds_plot.locations.create(name:'Powerline 2-man', coordinates:'POINT (-82.605562 33.446289)', location_type:1)
  @todds_plot.locations.create(name:'Tripod', coordinates:'POINT (-82.602665 33.445465)', location_type:1)
  @todds_plot.locations.create(name:'Don\'s 2-man', coordinates:'POINT (-82.59936 33.44525)', location_type:1)
  @todds_plot.locations.create(name:'Todd\'s 2-man', coordinates:'POINT (-82.596979 33.43046)', location_type:1)

  @mikes_plot.locations.create(name:'Pool', coordinates:'POINT (-84.469518 34.033362)', location_type:1)
  @mikes_plot.locations.create(name:'Middeke', coordinates:'POINT (-84.474517 34.038608)', location_type:1)
  @mikes_plot.locations.create(name:'Tallman', coordinates:'POINT (-84.47102 34.033104)', location_type:1)
  @mikes_plot.locations.create(name:'Lassiter Cut-through', coordinates:'POINT (-84.471937 34.040641)', location_type:1)
  @mikes_plot.locations.create(name:'Simpson Cut-through', coordinates:'POINT (-84.476309 34.033147)', location_type:1)
end

def make_hunting_plot_named_animals
  @todds_plot.named_animals.create!(name:'Swamp Donkey', animal_category_id: @trophy_buck_category.id)
  @todds_plot.named_animals.create!(name:'Pointy', animal_category_id: @mature_buck_category.id)

  @mikes_plot.named_animals.create!(name:'Grumpy', animal_category_id: @trophy_buck_category.id)
  @mikes_plot.named_animals.create!(name:'Doc', animal_category_id: @trophy_buck_category.id)
  @mikes_plot.named_animals.create!(name:'Sneezy', animal_category_id: @trophy_buck_category.id)
end

def make_user_plot_accesses
  @todds_plot.user_accesses.create!(user_id: @mike_user.id)
  @todds_plot.user_accesses.create!(user_id: @todd_user.id, :alias => 'Warrenton')
  @todds_plot.user_accesses.create!(user_id: @don_user.id)

  @mikes_plot.user_accesses.create!(user_id: @mike_user.id)
end

def make_user_posts
  create_user_posts @mike_user, 10
  create_user_posts @todd_user, 10
  create_user_posts @don_user, 10
  @other_users.each do |u|
    create_user_posts u, 20
  end
end

def create_user_posts(user, count)
  count.times do
    post = user.posts.build(post_content: Faker::Lorem.sentence(10, false, 10), visibility:1)
    post.created_at = rand(168).hours.ago
    post.save
  end
end

#require 'active_support'
#require 'active_support/core_ext/integer/time'
require 'json'

namespace :db do
  namespace :populate do

    desc 'Populate the animal configuration data'
    task animals: :environment do
      make_animal_species
      make_animal_categories
      make_animal_activity_types
    end

    desc 'Populate the user networks configuration data'
    task networks: :environment do
      make_user_networks
    end

    desc 'Populate the user profile items configuration data'
    task user_profile: :environment do
      make_user_profile_items
    end

    desc 'Populate all of the configuration data'
    task config_data: :environment do
      populate_config_data
    end
    desc 'Populate the test data (users, plots, etc)'
    task test_data: :environment do
      populate_test_data
    end
    desc 'Populate config and test data'
    task all: :environment do
      populate_config_data
      populate_test_data
    end
  end
end

def populate_config_data
  make_animal_species
  make_animal_categories
  make_animal_activity_types
  make_user_networks
  make_user_profile_items
end

def populate_test_data
  make_users
  make_user_relationships
  make_hunting_plots
  make_hunting_locations
  make_hunting_plot_named_animals
  make_user_plot_accesses
  make_user_posts
  make_user_networks
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
  @todds_plot.user_accesses.create!(user_id: @mike_user.id, permissions_can_administrate: true)
  @todds_plot.user_accesses.create!(user_id: @todd_user.id, permissions_can_administrate: true, :alias => 'Warrenton')
  @todds_plot.user_accesses.create!(user_id: @don_user.id, permissions_can_administrate: true)

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

def make_user_networks
  create_user_network_categories
  usa_network = UserNetwork.create(name: 'United States', category_id: @user_network_categories[:country])
  create_state_networks(usa_network.id)
  create_county_networks
end

def create_user_network_categories
  country_category = UserNetworkCategory.create(name:'Country', is_composite: true)
  state_category = UserNetworkCategory.create(name:'State', is_composite: true, parent_category_id: country_category.id)
  state_region_category = UserNetworkCategory.create(name:'State Region', is_composite: true, parent_category_id: state_category.id)
  region_category = UserNetworkCategory.create(name:'Region', is_composite: true, parent_category_id: country_category.id)
  county_category = UserNetworkCategory.create(name:'County', is_composite: false, parent_category_id: state_category.id)
  @user_network_categories =
    {
      country: country_category.id,
      state: state_category.id,
      region: region_category.id,
      state_region: state_region_category.id,
      county: county_category.id
    }
end

def create_state_networks(parent_network_id)
  [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ].each do |state_name|
    UserNetwork.create!(name: state_name, category_id: @user_network_categories[:state], parent_network_id: parent_network_id)
  end
end

def create_county_networks()
  georgia_state_network_id = UserNetwork.find_by(name: 'Georgia', category_id: @user_network_categories[:state]).id
  source_json = File.read("#{Rails.root}/lib/tasks/ga_county_boundaries.json")
  county_boundaries = JSON.parse(source_json)
  county_boundaries['county_boundaries'].each do |county|
    county_network = UserNetwork.create(name: county['county_name'], category_id: @user_network_categories[:county], parent_network_id: georgia_state_network_id)
    county['boundaries'].each do |boundary|
      county_network.boundaries.create!(boundary: boundary)
    end
  end
end

def make_user_profile_items

  UserProfileItem.create!(
    name: 'ageRange',
    label: 'Your age (years old)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_required: true,
    value_list: {
      items: [
        { value: '7-15', label: '7 - 15' },
        { value: '16-20', label: '16 - 20' },
        { value: '21-29', label: '21 - 29' },
        { value: '30-39', label: '30 - 39' },
        { value: '40-49', label: '40 - 49' },
        { value: '50-59', label: '50 - 59' },
        { value: '60-100', label: '60+' },
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'gender',
    label: 'Gender',
    data_type: UserProfileItem.data_types[:data_type_string],
    value_list: {
      items: [
        { value: 'M', label:'Male' },
        { value: 'F', label:'Female' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'typeOfHunting',
    label: 'Type of hunting you do (choose all that apply)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_multi_valued: true,
    value_list: {
      items: [
        { value: 'whiteTailDeer', label:'White Tail Deer' },
        { value: 'turkey', label:'Turkey' },
        { value: 'duck', label:'Duck' },
        { value: 'dove', label:'Dove' },
        { value: 'quail', label:'Quail' },
        { value: 'squirrel', label:'Squirrel' },
        { value: 'bear', label:'Bear' },
        { value: 'hog', label:'Hog' },
        { value: 'other', label:'Other' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'huntingFrequency',
    label: 'How often do you hunt (times per year)',
    data_type: UserProfileItem.data_types[:data_type_string],
    #flags_is_required: true,
    value_list: {
      items: [
        { value: '1-10', label: '1 - 10' },
        { value: '11-20', label: '11 - 20' },
        { value: '21-30', label: '21 - 30' },
        { value: '31+', label: '31+' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'useCameras',
    label: 'Do you use trail cameras?',
    data_type: UserProfileItem.data_types[:data_type_boolean]
  )

  UserProfileItem.create!(
    name: 'useFeeders',
    label: 'Do you use feeders?',
    data_type: UserProfileItem.data_types[:data_type_boolean]
  )

  UserProfileItem.create!(
    name: 'huntingStationType',
    label: 'What do you hunt from (choose all that apply)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_multi_valued: true,
    value_list: {
      items: [
        { value: 'stand', label:'Ladder or Box Stand' },
        { value: 'blind', label:'Ground Blind' },
        { value: 'slip', label:'Walk/Slip' },
        { value: 'climber', label:'Climber' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'weaponType',
    label: 'What type of weapon do you use (choose all that apply)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_multi_valued: true,
    value_list: {
      items: [
        { value: 'rifle', label:'Rifle' },
        { value: 'shotgun', label:'Shotgun' },
        { value: 'bow', label:'Bow' },
        { value: 'muzzle', label:'Muzzleloader' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'outdoorActivities',
    label: 'What other type of outdoor activities do you enjoy (choose all that apply)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_multi_valued: true,
    value_list: {
      items: [
        { value: 'camping', label:'Camping' },
        { value: 'fishing', label:'Fishing' },
        { value: 'hiking', label:'Hiking' },
        { value: 'skiing', label:'Skiing' },
        { value: 'climbing', label:'Climbing' }
      ]
    }.to_json
  )

  UserProfileItem.create!(
    name: 'plotType',
    label: 'What type of property do you hunt (choose all that apply)',
    data_type: UserProfileItem.data_types[:data_type_string],
    flags_is_multi_valued: true,
    value_list: {
      items: [
        { value: 'lease', label:'Hunting Lease' },
        { value: 'club', label:'Hunting Club' },
        { value: 'guide', label:'Guided Hunts' },
        { value: 'public', label:'Public Property' },
        { value: 'farm', label:'Family/Friend Farm' }
      ]
    }.to_json
  )

end

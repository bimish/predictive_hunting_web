# config/initializers/generators.rb
Rails.application.config.generators do |g|
  g.helper :modular_helper
  #g.scaffold_controller :model_scaffold_controller
  #g.test_framework :test_unit, fixture: false
  g.template_engine :all
  g.fallbacks[:all] = :erb # or haml/slim etc
end

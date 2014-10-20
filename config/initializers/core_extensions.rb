require Rails.root + 'lib/app/activemodel_extensions'
# Add initialization content here
ActiveRecord::Base.send :include, ActiveModel::Decorators

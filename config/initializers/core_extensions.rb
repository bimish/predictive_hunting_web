require Rails.root + 'lib/activemodel_extensions'
# Add initialization content here
ActiveRecord::Base.send :include, ActiveModel::Decorators

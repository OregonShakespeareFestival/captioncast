# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.

Rails.application.config.assets.compile = true
Rails.application.config.assets.digest  = true
Rails.application.config.assets.precompile =  %w( '*.css' )
Rails.application.config.assets.precompile += %w( '*.css.erb' )
Rails.application.config.assets.precompile += %w( application.css )
Rails.application.config.assets.precompile += %w( 'rails_admin/rails_admin.css' )
Rails.application.config.assets.precompile += %w( 'rails_admin/rails_admin.js' )
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( cast.js )
Rails.application.config.assets.precompile += %w( display.js )
Rails.application.config.assets.precompile += %w( editor.js )
Rails.application.config.assets.precompile += %w( fixtures.js )
Rails.application.config.assets.precompile += %w( operator.js )
Rails.application.config.assets.precompile += %w( upload.js )
Rails.application.config.assets.precompile += %w( works.js )
Rails.application.config.assets.precompile += %w( texts.js )
Rails.application.config.assets.precompile += %w( logo.png )

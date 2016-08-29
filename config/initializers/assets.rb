# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(admin.css admin.js jetsteals.css jetsteals.js operators.css operators.js organisations.css organisations.js vendors/bg-slider/bar.js vendors/bg-slider/vegas.min.js vendors/bg-slider/slider_vegas_app.min.js)
Rails.application.config.assets.precompile += %w( vendors/bg-slider/bar.js )
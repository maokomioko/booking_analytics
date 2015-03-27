# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# iCheck images
Rails.application.config.assets.precompile +=
    %w(aero blue green grey minimal orange pink purple red yellow).inject([]) do |arr, v|
      arr << "icheck/minimal/#{v}.png"
      arr << "icheck/minimal/#{v}@2x.png"
      arr
    end

Rails.application.config.assets.precompile += %w(
  pages/auth_pages.js pages/fileuploader.js pages/fileuploader.css pages/company.js
  pages/invitation_new.js pages/invitation_new.css
)

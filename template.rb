# frozen_string_literal: true

require 'fileutils'
require 'shellwords'

require 'rails/generators/active_record/migration'

module MigrationHelpers
  # Implement the required interface for Rails::Generators::Migration.
  def next_migration_number(_dirname)
    @next_migration_number ||= Time.now.utc
    @next_migration_number += 1
    @next_migration_number.strftime('%Y%m%d%H%M%S')
  end
end

extend Rails::Generators::Migration
self.class.extend Rails::Generators::Migration::ClassMethods
self.class.extend MigrationHelpers

def apply_template!
  add_template_repository_to_source_path

  run_with_clean_bundler_env 'bin/rails webpacker:install'

  directory 'app'
  directory 'config'
  directory 'spec'

  route "root to: 'pages#home'"
  add_controller_routes
  add_devise_routes

  install_tailwind_css
  install_stimulus_js

  migration_template 'db/migrate/create_user_accounts.rb', 'db/migrate/create_user_accounts.rb'
end

# =============== Utils ===============

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'
    source_paths.unshift(tempdir = Dir.mktmpdir('rails-template-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/bmorrall/rockstart-tailwindcss-webapp.git',
      tempdir
    ].map(&:shellescape).join(' ')

    if (branch = __FILE__[%r{rockstart-tailwindcss-webapp/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              if Bundler.respond_to?(:with_unbundled_env)
                Bundler.with_unbundled_env { run(cmd) }
              else
                Bundler.with_clean_env { run(cmd) }
              end
            else
              run(cmd)
            end
  return if success

  puts "Command failed, exiting: #{cmd}"
  exit(1)
end

# =============== Setup ===============

def add_controller_routes
  route 'resource :dashboard, only: :show'
  route 'resources :notifications, only: :index'
end

def add_devise_routes
  route <<~DEVISE
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
    devise_scope :user do
      get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
      delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
    end
  DEVISE
end

# =============== Frontend ===============

def install_tailwind_css
  tailwind_modules = %w[
    postcss
    autoprefixer
    tailwindcss
    @tailwindcss/forms
    @tailwindcss/typography
    @tailwindcss/aspect-ratio
  ]
  run_with_clean_bundler_env "yarn add #{tailwind_modules.join(' ')}"
  template 'postcss.config.js'
  append_to_file 'app/javascript/packs/application.js' do
    "\nimport \"stylesheets/application\"\n"
  end
end

def install_stimulus_js
  stimulus_modules = %w[
    stimulus
    tailwindcss-stimulus-components
  ]
  run_with_clean_bundler_env "yarn add #{stimulus_modules.join(' ')}"
  append_to_file 'app/javascript/packs/application.js' do
    "\nrequire(\"controllers\")\n"
  end
end

apply_template!

class TinyUserGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions "User", "UserSession", "UsersController", "UserSessionsController", "PasswordResetsController", "Admin::UsersController", "Role::Admin", "Role::User"

      # Model, controller, view and test directories.
      m.directory 'app/models'
      m.directory 'app/models/role'
      m.directory 'app/controllers'
      m.directory 'app/controllers/admin'
      m.directory 'app/views/admin/users'
      m.directory 'app/views/password_resets'
      m.directory 'app/views/password_resets_mailer'
      m.directory 'app/views/user_sessions'
      m.directory 'app/views/users'
      m.directory 'test/unit'
      m.directory 'test/functional'

      # Classes and tests.
      m.file "admin_users_controller.rb", 'app/controllers/admin/users_controller.rb'
      m.file "password_resets_controller.rb", 'app/controllers/password_resets_controller.rb'
      m.file "role/admin.rb", 'app/models/role/admin.rb'
      m.file "role/user.rb", 'app/models/role/user.rb'
      m.file "user.rb", 'app/models/user.rb'
      m.file "user_session.rb", 'app/models/user_session.rb'
      m.file "user_sessions_controller.rb", 'app/controllers/user_sessions_controller.rb'
      m.file "users_controller.rb", 'app/controllers/users_controller.rb'
      
      # Views
      base_dir = File.dirname(__FILE__) + '/templates'
      Dir.glob("#{base_dir}/**/*.html.erb") do |template|
        relative_path = template.gsub("#{base_dir}/", '')
        m.file relative_path, "app/views/#{relative_path}"
      end
      
      # Migrations
      m.migration_template 'create_users.rb', 'db/migrate', :migration_file_name => 'create_users.rb'
    end
  end
end

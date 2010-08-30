module TinyCore
  module Acts
    module User
      module ActsMethods
        def acts_as_user
          acts_as_authentic
          validates_presence_of :full_name

          attr_protected :role

          extend ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
        def from_param!(param)
          find(param)
        end

        def paginate_for_list(filter, options = {})
          with_search_scope(filter) do
            paginate(options.merge(:order => 'users.created_at DESC'))
          end
        end

      protected
        def with_search_scope(filter, &block)
          conditions = filter.empty? ? nil : ['users.full_name LIKE ? OR users.email LIKE ?', "%#{filter.query}%", "%#{filter.query}%"]
          with_scope :find => { :conditions => conditions } do
            yield
          end
        end
      end

      module InstanceMethods
        def after_initialize
          if self.role.blank?
            extend ::Role::User
          else
            extend "::Role::#{self.role.classify}".constantize
          end
        end

        def deliver_password_reset_instructions!
          reset_perishable_token!
          PasswordResetsMailer.deliver_password_reset_instructions(self)
        end

        def reset_password!(password, password_confirmation)
          # We need to check for blank password explicitly, because authlogic only performs that check on create.
          if password.blank? || password_confirmation.blank?
            errors.add(:password, I18n.t('authlogic.error_messages.password_blank'))
            return false
          else
            self.password = password
            self.password_confirmation = password_confirmation
            save
          end
        end

        def name
          full_name
        end
        
        def guest?
          false
        end
      end
      
      def self.included(receiver)
        receiver.extend ActsMethods
      end
    end
  end
end

ActiveRecord::Base.send :include, TinyCore::Acts::User

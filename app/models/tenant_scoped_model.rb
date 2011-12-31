# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Scope Model
#
# TenantScopedModel manages all multi tenant system for more information see the Samuek Kadolph blog.
# * http://samuel.kadolph.com/2010/12/simple-rails-multi-tenancy/
# * http://samuel.kadolph.com/2011/12/simple-rails-multi-tenancy-ii/
class TenantScopedModel < ActiveRecord::Base
  class << self

    # Public Static: Built default scope
    def build_default_scope
      if method(:default_scope).owner != ActiveRecord::Base.singleton_class
        evaluate_default_scope { default_scope }
      elsif default_scopes.any?
        evaluate_default_scope do
          default_scopes.inject(relation) do |default_scope, scope|
            if scope.is_a?(Hash)
              default_scope.apply_finder_options(scope)
            elsif !scope.is_a?(ActiveRecord::Relation) && scope.respond_to?(:call)
              if scope.respond_to?(:arity) && scope.arity == 1
                scope = scope.call(self)
              else
                scope = scope.call
              end
              default_scope.merge(scope)
            else
              default_scope.merge(scope)
            end
          end
        end
      end
    end
  end

  self.abstract_class = true

  belongs_to :tenant
  validates  :tenant, :presence => true

  # Public:  Set where condition all query
  #
  # This is the heart of multi tenant system
  default_scope do |model|
    model.where(:tenant_id => Tenant.current)
  end
end
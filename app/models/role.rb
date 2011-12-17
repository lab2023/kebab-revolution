class Role < TenantScopedModel
  translates  :name
  validates   :name, :presence => true
end
class Role < TenantScopedModel
  translates  :name, :fallbacks_for_empty_translations => true
  validates   :name, :presence => true
end
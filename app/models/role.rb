class Role < TenantScopedModel
  has_and_belongs_to_many :users
  validates   :name, :presence => true
  translates  :name, :fallbacks_for_empty_translations => true
end
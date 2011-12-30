class Privilege < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :apps
  has_and_belongs_to_many :resources

  validates   :sys_name,  :presence => true, :uniqueness => true
  validates   :name,      :presence => true

  translates  :name, :info, :fallbacks_for_empty_translations => true
end

class App < ActiveRecord::Base
  has_and_belongs_to_many :privileges

  validates  :sys_name,       :presence => true, :uniqueness => true
  validates  :sys_department, :presence => true
  translates :name, :fallbacks_for_empty_translations => true
end

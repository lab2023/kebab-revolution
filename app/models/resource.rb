class Resource < ActiveRecord::Base
  has_and_belongs_to_many :privileges
  validates   :sys_path,  :presence => true, :uniqueness => true
  validates   :sys_name,  :presence => true, :uniqueness => true
end

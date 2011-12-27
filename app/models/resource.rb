class Resource < ActiveRecord::Base
  has_many    :privileges
  validates   :sys_name,  :presence => true, :uniqueness => true
end

class Service < ActiveRecord::Base
  belongs_to :privilege
  validates  :controller, :presence => true
  validates  :action,     :presence => true
  validates  :privilege,  :presence => true
end

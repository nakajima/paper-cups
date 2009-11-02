class Room < ActiveRecord::Base
  has_many :memberships
  has_many :members, :through => :memberships, :order => :email
  has_many :messages, :order => :created_at
  
  private
  
  validates_presence_of :label
end
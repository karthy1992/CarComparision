class Model < ActiveRecord::Base
	belongs_to :manufacturer 
	has_many :variants
	has_many :features
	validates_uniqueness_of :name
end

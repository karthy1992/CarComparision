class Manufacturer < ActiveRecord::Base
	has_many :models, foreign_key: 'manufacturer_id'
	validates_uniqueness_of :name
end

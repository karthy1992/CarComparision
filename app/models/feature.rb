class Feature < ActiveRecord::Base
	belongs_to :model
  validates_uniqueness_of :featurename
	def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|feature| [feature.featurename,feature.model_id] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end
end

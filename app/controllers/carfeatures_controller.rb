class CarfeaturesController < ApplicationController
	
	require 'set'

	def getfeatures
        @manufacturerid1 = params[:manufacturer1][:id]
        @modelid1        = params[:model1][:id]
        @variantid1      = params[:variant1][:id]
        
        

        @manufacturername1 = Manufacturer.find(@manufacturerid1).name
        @modelname1        = Model.find(@modelid1).name
        @variantname1      = Variant.find(@variantid1).name
        
        @variantfeatures1 = Variantfeature.where(variant_id: @variantid1)
        
       
        @safetyfeatures = Set.new
        @comfortfeatures = Set.new
        @variantfeatures1.each do |variantfeature1|
        	if Feature.find_by(id: variantfeature1.feature_id, featurecategory: "safety").nil?
        		@comfortfeatures.add(Feature.find_by(id: variantfeature1.feature_id, featurecategory: "comfort").id)
        		next
        	end
        	@safetyfeatures.add(Feature.find_by(id: variantfeature1.feature_id, featurecategory: "safety").id)
        end 


        @manufacturerid2 = params[:manufacturer2][:id]
        @modelid2        = params[:model2][:id]
        @variantid2      = params[:variant2][:id]
        
        

        @manufacturername2 = Manufacturer.find(@manufacturerid2).name
        @modelname2        = Model.find(@modelid2).name
        @variantname2      = Variant.find(@variantid2).name
        
        @variantfeatures2 = Variantfeature.where(variant_id: @variantid2)

        @variantfeatures2.each do |variantfeature2|
        	if Feature.find_by(id: variantfeature2.feature_id, featurecategory: "safety").nil?
        		@comfortfeatures.add(Feature.find_by(id: variantfeature2.feature_id, featurecategory: "comfort").id)
        		next
        	end
        	@safetyfeatures.add(Feature.find_by(id: variantfeature2.feature_id, featurecategory: "safety").id)
        end 

        puts "SafetyFeatures ID"

        @safetyfeatures.each do |safetyfeature|
        	puts safetyfeature
        end


        puts "Comfort Features ID"

        @comfortfeatures.each do |comfortfeature|
        	puts comfortfeature
        end

	end
end

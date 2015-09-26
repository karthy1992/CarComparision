class CrawlerController < ApplicationController

  require 'anemone'
  require 'nokogiri'
  require 'open-uri'
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def getinput
  end

  def crawl
  	@name = params[:name]
  	@url   = params[:url] 	
  	insertmanufacturerdetails
  	findmodels
    displaymodelandvariantdetails
    findvariants
    displayvariants
    findsafetysecurityfeature
    findcomfortfeature
    displaymodelfeatures
    fillvariantsafetyfeaturetable
    fillvariantcomfortfeaturetable
    printvariantfeatures
    printvariantfeaturetable
  end

  def printvariantfeaturetable
    @variantfeatures = Variantfeature.all
    @variantfeatures.each do |variantfeature|
      puts variantfeature.variant_id , variantfeature.feature_id
    end
  end

  def printvariantfeatures
    Variantfeature.dedupe
    @models = Model.all
    @models.each do |model|
      puts model.name
      model.variants.each do |variant|
        puts variant.name
        variantfeatures = Variantfeature.where(variant_id: variant.id)
        variantfeatures.each do |variantfeature|
         @feature = Feature.find_by(id: variantfeature.feature_id)
         puts @feature.featurename, @feature.featuretype
       end
     end
   end
  end

   def fillvariantsafetyfeaturetable
     Variant.dedupe
     @models = Model.all
     @models.each do |model|
      htmlmodeldoc = Nokogiri::HTML(open(model.website))
      if htmlmodeldoc.at_css("div#safetysecurity")
        puts model.name
        model.variants.each do |variant|
          @safetyfeaturestable    = htmlmodeldoc.css("div#safetysecurity").css("table")[0]
          variantindex     = -1
          count = -1
          @safetyfeaturestable.css("tbody")[0].css("tr")[0].css("td").each do | td |
            count=count+1
            if td.text.gsub(/\s+/, "") == variant.name
              variantindex = count    
              break
            end
          end

          isfirst = true
          @safetyfeaturestable.css("tbody")[0].css("tr").each do |tr|
           if isfirst 
            isfirst = false
            next
          end
          if(tr.css("td")[variantindex].text.gsub(/\s+/, "") != "No")
            @feature = model.features.find_by(featurename: tr.css("td")[1].text.gsub("/\s+/", " ").strip())
            Variantfeature.create(variant_id: variant.id , feature_id: @feature.id)
          #puts model.name , variant.name , variant.featureid, @feature.featurename
        end

      end

    end 
  end
end
end

def fillvariantcomfortfeaturetable
     Variant.dedupe
     @models = Model.all
     @models.each do |model|
      htmlmodeldoc = Nokogiri::HTML(open(model.website))
      if htmlmodeldoc.at_css("div#seat")
        puts model.name
        model.variants.each do |variant|
          @safetyfeaturestable    = htmlmodeldoc.css("div#seat").css("table")[0]
          variantindex     = -1
          count = -1
          @safetyfeaturestable.css("tbody")[0].css("tr")[0].css("td").each do | td |
            count=count+1
            if td.text.gsub(/\s+/, "") == variant.name
              variantindex = count    
              break
            end
          end

          isfirst = true
          @safetyfeaturestable.css("tbody")[0].css("tr").each do |tr|
           if isfirst 
            isfirst = false
            next
          end
          if(tr.css("td")[variantindex].text.gsub(/\s+/, "") != "No")
            @feature = model.features.find_by(featurename: tr.css("td")[1].text.gsub("/\s+/", " ").strip())
            Variantfeature.create(variant_id: variant.id , feature_id: @feature.id)
            puts model.name , variant.name ,@feature.id, @feature.featurename
        end

      end

    end 
  end
end
end





def displaymodelfeatures
  Feature.dedupe
  @models = Model.all
  @models.each do |model|
   puts model.name
   model.features.each do |feature|
    puts feature.featurename , feature.featurecategory
  end
end
end

def findsafetysecurityfeature
  @models = Model.all
  @models.each do |model|
    htmlmodeldoc = Nokogiri::HTML(open(model.website))
    isfirst=true;
    if htmlmodeldoc.at_css("div#safetysecurity")
      puts model.name
      htmlmodeldoc.css("div#safetysecurity").css("table")[0].css("tbody")[0].css("tr").each do |tdata|
       if isfirst
        isfirst = false
        next
      end
      model.features.create(featurename: tdata.css("td")[1].text.gsub("/\s+/", " ").strip() , featurecategory: "safety" )
    end
  end
end
end

def findcomfortfeature
  @models = Model.all
  @models.each do |model|
    htmlmodeldoc = Nokogiri::HTML(open(model.website))
    isfirst=true;
    if htmlmodeldoc.at_css("div#seat")
      puts model.name
      htmlmodeldoc.css("div#seat").css("table")[0].css("tbody")[0].css("tr").each do |tdata|
       if isfirst
        isfirst = false
        next
      end
      model.features.create(featurename: tdata.css("td")[1].text.gsub("/\s+/", " ").strip(), featurecategory: "comfort" ) 
    end
  end
end
end


def displaymodelandvariantdetails
  Variant.dedupe
  @models = Model.all
  @models.each do |model|
    puts model.name
    model.variants.each do |variant|
      puts variant.name
    end
  end
end

def insertmanufacturerdetails
 @manufacturer = Manufacturer.new(name: @name, website: @url)
 if @manufacturer.save
  puts @manufacturer.name, @manufacturer.website
end
end

def findmodels
 @manufacturer = Manufacturer.find_by(name: @name)
 puts @manufacturer.website
 @htmldoc          = Nokogiri::HTML(open(@url.to_s))
 @htmltext         = @htmldoc.text         
 @uldetails  = @htmldoc.css('ul.flr_list.footeropen')
 @uldetails.each do |ul| 
   ul.css("li").each do |li|
    puts li.css("a")[0]["href"] , li.text
    @model = @manufacturer.models.create(name: li.text, website: li.css("a")[0]["href"])
  end
end
end
def displaymodels
  @models = Model.all;
  @models.each do |model|
    puts model.name , model.website , model.manufacturer_id , model.id
  end

end

def findvariants
  @models = Model.all
  @models.each do |model|
      #puts model.name
      htmlmodeldoc = Nokogiri::HTML(open(model.website))
      if htmlmodeldoc.at_css("div#safty_secur")
        # puts "checking:" , model.name
        htmlmodeldoc.css("div#safty_secur").css("table")[0].css("tbody")[0].css("tr")[0].css("th").each do |tdata|
          tdata = tdata.text.gsub(/\s+/, "")
          if not tdata.to_s.blank?
           #puts model.name
           #puts tdata
           #model.variants.create(name: tdata)
         end
       end
     elsif htmlmodeldoc.at_css("div#safetysecurity")
       htmlmodeldoc.css("div#safetysecurity").css("table")[0].css("tbody")[0].css("tr")[0].css("td").each do |tdata|
        tdata = tdata.text.gsub(/\s+/, "")
        if not tdata.to_s.blank?
         puts model.name
         puts tdata
         model.variants.create(name: tdata)
       end
     end
   end
 end 
end

def displayvariants
  @variants = Variant.all
  @variants.each do |variant|
    puts variant.name
  end
end

end


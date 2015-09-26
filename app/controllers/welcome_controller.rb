class WelcomeController < ApplicationController
  def index
  	@manufacturers = Manufacturer.all
  	@models= Model.all
  	@variants = Variant.where("model_id=?",Model.first.id)
  end
  def show
    @variant = Variant.find_by("id = ?", params[:variant][:id])
  end
  def update_variants
    @variants = Variant.where("model_id = ?", params[:model_id])
    puts params[:model_id]
    puts "## it is coming inside"
    respond_to do |format|
      format.json { 
        render json: @variants
      }
    end
  end
   def getform
      render partial: 'carcompareform', format: 'html'
   end
end

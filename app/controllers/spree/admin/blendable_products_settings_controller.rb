class Spree::Admin::BlendableProductsSettingsController < Spree::Admin::ResourceController     
  respond_to :json, :only => [:get_children]

  def get_children
    @products = Products.find(params[:parent_id]).children
    
    respond_with(@products)
  end
  
  private 
  
  def location_after_save
    if @blendabletaxon.created_at == @blendabletaxon.updated_at
      edit_admin_blendable_taxon_url(@blendabletaxon)
    else
      admin_blendable_taxon_url
    end
  end
end
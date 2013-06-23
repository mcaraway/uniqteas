Spree::Admin::TaxonomiesController.class_eval do
  def rebuild
    Spree::Taxon.rebuild! 
    flash[:success] = "Taxonomies tree rebuilt."
    respond_to do |format|
      format.html { redirect_to admin_taxonomies_url }
      format.js   { render :layout => false }
    end
  end
end
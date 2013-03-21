class Spree::Admin::HomePageSlidersController < Spree::Admin::ResourceController
  before_filter :load_data, :except => :index
  def index
    @home_page_sliders = Spree::HomePageSlider.all
  end

  protected

  def location_after_save
    if @home_page_slider.created_at == @home_page_slider.updated_at
      edit_admin_home_page_slider_url(@home_page_slider)
    else
      edit_admin_home_page_slider_url(@home_page_slider)
    end
  end

  def load_data
  end
end

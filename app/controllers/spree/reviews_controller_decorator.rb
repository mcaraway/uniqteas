Spree::ReviewsController.class_eval do
  def create
      #params[:review][:rating].sub!(/\s*stars/,'') unless params[:review][:rating].blank?

      @review = Spree::Review.new
      @review.name = params[:review][:name]
      @review.review = params[:review][:review]
      @review.rating = params[:review][:rating].to_f
      @review.product = @product
      @review.user = try_spree_current_user
      @review.location = request.remote_ip
      authorize! :create, @review
      if @review.save
        flash[:notice] = t('review_successfully_submitted')
        respond_to do |format|
          format.js { render "success", :status => 201 }
        end
      else
        respond_to do |format|
          format.js { render "error", :status => 422 }
        end
      end
    end
end
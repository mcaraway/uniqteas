class Spree::LabelTemplatesController < Spree::ResourceController
  # GET /label_templates
  # GET /label_templates.json
  def index
    @label_templates = LabelTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @label_templates }
    end
  end

  # GET /label_templates/1
  # GET /label_templates/1.json
  def show
    @label_template = LabelTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @label_template }
    end
  end

  # GET /label_templates/new
  # GET /label_templates/new.json
  def new
    @label_template = LabelTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @label_template }
    end
  end

  # GET /label_templates/1/edit
  def edit
    @label_template = LabelTemplate.find(params[:id])
  end

  # POST /label_templates
  # POST /label_templates.json
  def create
    @label_template = LabelTemplate.new(params[:label_template])

    respond_to do |format|
      if @label_template.save
        format.html { redirect_to @label_template, notice: 'Label template was successfully created.' }
        format.json { render json: @label_template, status: :created, location: @label_template }
      else
        format.html { render action: "new" }
        format.json { render json: @label_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /label_templates/1
  # PUT /label_templates/1.json
  def update
    @label_template = LabelTemplate.find(params[:id])

    respond_to do |format|
      if @label_template.update_attributes(params[:label_template])
        format.html { redirect_to @label_template, notice: 'Label template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @label_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /label_templates/1
  # DELETE /label_templates/1.json
  def destroy
    @label_template = LabelTemplate.find(params[:id])
    @label_template.destroy

    respond_to do |format|
      format.html { redirect_to label_templates_url }
      format.json { head :no_content }
    end
  end
end

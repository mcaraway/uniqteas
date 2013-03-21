module Paperclip
  class Composite < Processor
    # Handles compositing of images that are uploaded.
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :template_path, :variant_id, :label_image_remote_url
    def initialize file, options = {}, attachment = nil
      super
      geometry          = options[:geometry]
      @file             = file
      @target_geometry  = Geometry.parse geometry
      @current_geometry = Geometry.from_file @file
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @format           = options[:format]
      @template_path    = options[:template_path]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @variant_id      = options[:variant_id]
      @label_image_remote_url = options[:label_image_remote_url]
    end
    
    # Performs the conversion of the +file+. Returns the Tempfile
    # that contains the new image.
    def make
      Paperclip.log("***********  Product is custom!  Compositing...")
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode
      
      if @label_image_remote_url != nil
        dst = make_with_template(dst)
      else
        dst = make_with_image(dst)
      end
      
      dst
    end
    
    def make_with_template(dst)
      Paperclip.log("***********  Make with template...")
      # composite the image onto the template
      comp = Tempfile.new(["comp",".png"])
      comp.binmode
      
      command = "composite"
      params = "-geometry 100x133!+70+40 #{fromfile} #{template_path} #{tofile(comp)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error processing the composite for #{@basename} with params #{params}" if @whiny
      end
      
      # composite the name onto the destination image
      # first create the text image
      dst = compositeTextToFile(productName, comp, "89x14!+76+43")
      
      dst
    end
    
    def make_with_image(dst)
      Paperclip.log("***********  Make with image...")
      comp = Tempfile.new(["comp",".png"])
      comp.binmode
      
      # composite the image onto the template
      command = "composite"
      params = "-geometry 89x68!+76+63 #{fromfile} #{template_path} #{tofile(comp)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error processing the composite for #{@basename} with params #{params}" if @whiny
      end

      # composite the name onto the destination image
      # first create the text image
      dst = compositeTextToFile(productName, comp, "89x14!+76+43")
      
      dst
    end
    
    def compositeTextToFile(text, file, location)
      dst = Tempfile.new(["tempDst",".png"])
      dst.binmode
            
      # composite the name onto the destination image
      # first create the text image
      textImg = Tempfile.new(["text",".png"])
      textImg.binmode
      
      command = "convert"
      params = "-background none -fill black -font Arial -pointsize 12 label:\"#{text}\" #{tofile(textImg)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error creating the text img params #{params}" if @whiny
      end
      
      # now composite text onto dst
      command = "composite"
      params = "-geometry " + location +" #{tofile(textImg)} #{tofile(file)} #{tofile(dst)}"
      begin
        success = Paperclip.run(command, params)
      rescue Cocaine::CommandLineError => ex
        raise PaperclipError, "There was an error compositing the text onto the template with params #{params}" if @whiny
      end      
      
      dst
    end
    
    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      File.expand_path(destination.path)
    end
    
    def productName
      variant = Spree::Variant.find_by_id(@variant_id)
      variant ? variant.name.strip : "Tea Name"
    end
    
    def productDescription
      variant = Spree::Variant.find_by_id(@variant_id)
      variant ? variant.description.strip : "Tea Description"
    end
  end
end
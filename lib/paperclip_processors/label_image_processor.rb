module Paperclip
  class LabelImageProcessor < Processor
    # Handles compositing of images that are uploaded.
    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :name, :template_path, :description, :generate_tin_image
    def initialize file, options = {}, attachment = nil
      super
      geometry          = options[:geometry]
      @file             = file
      @target_geometry  = Geometry.parse geometry
      @current_geometry = Geometry.from_file @file
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
      @format           = options[:format]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @name             = options[:name]
      @description      = options[:description]
      @template_path    = options[:template_path]
      @generate_tin_image = options[:generate_tin_image]
    end
    
    # Performs the conversion of the +file+. Returns the Tempfile
    # that contains the new image.
    def make
      if !@generate_tin_image
        return
      end
      
      Paperclip.log("***********  Label Image Processor...")
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

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
      textImg = Tempfile.new(["text",".png"])
      textImg.binmode
      
      command = "convert"
      params = "-background none -fill black -font Arial -pointsize 12 label:\"#{name}\" #{tofile(textImg)}"

        success = Paperclip.run(command, params)

      
      # now composite text onto dst
      command = "composite"
      params = "-geometry 89x14!+76+43 #{tofile(textImg)} #{tofile(comp)} #{tofile(dst)}"

        success = Paperclip.run(command, params)

      
      dst
    end
    
    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      File.expand_path(destination.path)
    end
   
  end
end
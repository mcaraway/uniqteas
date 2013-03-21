require 'spree_core'
 
module UniqTeas
  class Engine < Rails::Engine
 
    config.autoload_paths += %W(#{config.root}/lib)
 
    def self.activate
      Image.attachment_definitions[:attachment].merge!(
      processors => [:composite]
      )
    end
 
    config.to_prepare &method(:activate).to_proc
  end
end
Deface::Override.new(:virtual_path => "spree/products/index",
                     :name => "add_blend_it_20120918",
                     :insert_before => "[data-hook='homepage_products'], #homepage_products[data-hook]",
                     :partial => "spree/shared/instructions")
Deface::Override.new(:virtual_path => 'spree/products/_custom_product',
                     :name => 'add_social_buttons_to_custom_products_show',
                     :insert_after => "[data-hook='cart_form']",
                     :partial => 'spree/shared/social_buttons')
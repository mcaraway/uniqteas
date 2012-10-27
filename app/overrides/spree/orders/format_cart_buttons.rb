Deface::Override.new(:virtual_path => "spree/orders/edit",
                     :name => "format_cart_buttons",
                     :replace => "[data-hook='cart_buttons'], #cart_buttons[data-hook]",
                     :partial => "spree/orders/cart_buttons")
                     
Deface::Override.new(:virtual_path => "spree/orders/_line_item",
                     :name => "format_cart_buttons",
                     :replace => "[data-hook='cart_item_quantity'], #cart_item_quantity[data-hook]",
                     :partial => "spree/orders/line_item_quantity")
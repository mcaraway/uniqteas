Deface::Override.new(:virtual_path => "spree/admin/products/index",
                     :name => "add_reprocess_images_button",
                     :insert_bottom => "[data-hook='toolbar'], #toolbar[data-hook]",
                     :text => "<ul class='actions header-action-links inline-menu'><li id='reporcess_product_images_link'><%= button_link_to t(:reprocess_images), spree.reprocess_images_admin_label_templates_url, :method => :post, :icon => 'icon-refresh', :id => 'reprocess_images_admin_label_templates_link' %></li></ul>",
                     :original => '3e847740dc3e7fasda1ccb56645466676j734hskk')
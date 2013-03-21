Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "home_page_slider_tabs",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :text => "<%= tab(:home_page_sliders, :url => spree.admin_home_page_sliders_path, :icon => 'icon-random') %>",
                     :disabled => false,
                     :original => '3e847740dc3e7f924aba1ccb566e9898f73734hskk')
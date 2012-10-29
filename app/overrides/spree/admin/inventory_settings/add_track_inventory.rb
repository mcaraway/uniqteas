Deface::Override.new(:virtual_path => "spree/admin/inventory_settings/edit",
                     :name => "add_track_inventory",
                     :insert_before => "[data-hook='allow_backorders'], #allow_backorders[data-hook]",
                     :partial => "spree/admin/inventory_settings/track_inventory")
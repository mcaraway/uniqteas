    Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                         :name => "clean_header",
                         :replace => "[data-hook='header'], header#header",
                         :partial => "spree/shared/header_clean")
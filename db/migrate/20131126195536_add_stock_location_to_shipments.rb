class AddStockLocationToShipments < ActiveRecord::Migration
  def change
    location = Spree::StockLocation.find_by_name('default')
    Spree::Shipment.update_all(stock_location_id: location.id)    
  end
end

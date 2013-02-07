class SetupTeaPrototypes < ActiveRecord::Migration
  def up
    # create tea prototype
    tea_prototype = Spree::Prototype.find_by_name("Tea")
    if (tea_prototype == nil)
      tea_prototype = Spree::Prototype.create({:name => "Tea"})
    end
    
    # associate flavor profile properties to tea prototype
    sweetness = Spree::Property.find_by_name("sweetness")
    fruity = Spree::Property.find_by_name("fruity")
    nutty = Spree::Property.find_by_name("nutty")
    vegetal = Spree::Property.find_by_name("vegetal")
    woody = Spree::Property.find_by_name("woody")
    aroma = Spree::Property.find_by_name("aroma")
    spicy = Spree::Property.find_by_name("spicy")
    floral = Spree::Property.find_by_name("floral")
    strength = Spree::Property.find_by_name("strength")
    
    tea_prototype.property_ids = [sweetness.id, fruity.id, nutty.id, vegetal.id, woody.id, aroma.id, spicy.id, floral.id, strength.id]
    
    if !tea_prototype.save()
      raise "There was an error saving tea prototype"
    end
    
    #create custom tea prototype
    custom_tea_prototype = Spree::Prototype.find_by_name("CustomTea")
    if (custom_tea_prototype == nil)
      custom_tea_prototype = Spree::Prototype.create({:name => "CustomTea"})
    end
    
    # associate flavor info and flavor profile properties to tea prototype
    flavor1name = Spree::Property.find_by_name("flavor1name")
    flavor2name = Spree::Property.find_by_name("flavor2name")
    flavor3name = Spree::Property.find_by_name("flavor3name")
    flavor1percent = Spree::Property.find_by_name("flavor1percent")
    flavor2percent = Spree::Property.find_by_name("flavor2percent")
    flavor3percent = Spree::Property.find_by_name("flavor3percent")
    flavor1sku = Spree::Property.find_by_name("flavor1sku")
    flavor2sku = Spree::Property.find_by_name("flavor2sku")
    flavor3sku = Spree::Property.find_by_name("flavor3sku")
    
    custom_tea_prototype.property_ids = [
      flavor1name.id, flavor2name.id, flavor3name.id,
      flavor1percent.id, flavor2percent.id, flavor3percent.id,
      flavor1sku.id, flavor2sku.id, flavor3sku.id, 
      sweetness.id, fruity.id, nutty.id, vegetal.id, woody.id, aroma.id, spicy.id, floral.id, strength.id]

    if !custom_tea_prototype.save()
      raise "There was an error saving custom tea prototype"
    end
  end
  
  def down 
    Spree::Prototype.where(:name => "Tea").first.destroy()
    Spree::Prototype.where(:name => "CustomTea").first.destroy()
  end
end
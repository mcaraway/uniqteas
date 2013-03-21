class SetupTeaProperties < ActiveRecord::Migration
  def up
    # make sure flavor names exists
    flavor1name = Spree::Property.find_by_name("flavor1name")
    if (flavor1name == nil)
      flavor1name = Spree::Property.create({:name => "flavor1name", :presentation => "First Flavor"})
    end
    flavor2name = Spree::Property.find_by_name("flavor2name")
    if (flavor2name == nil)
      flavor2name = Spree::Property.create({:name => "flavor2name", :presentation => "Second Flavor"})
    end
    flavor3name = Spree::Property.find_by_name("flavor3name")
    if (flavor3name == nil)
      flavor3name = Spree::Property.create({:name => "flavor3name", :presentation => "Third Flavor"})
    end
    
    # make sure flavor percentages exists
    flavor1percent = Spree::Property.find_by_name("flavor1percent")
    if (flavor1percent == nil)
      flavor1percent = Spree::Property.create({:name => "flavor1percent", :presentation => "First Flavor %"})
    end
    flavor2percent = Spree::Property.find_by_name("flavor2percent")
    if (flavor2percent == nil)
      flavor2percent = Spree::Property.create({:name => "flavor2percent", :presentation => "Second Flavor %"})
    end
    flavor3percent = Spree::Property.find_by_name("flavor3percent")
    if (flavor3percent == nil)
      flavor3percent = Spree::Property.create({:name => "flavor3percent", :presentation => "Third Flavor %"})
    end
    
    # make sure flavor skus exists
    flavor1sku = Spree::Property.find_by_name("flavor1sku")
    if (flavor1sku == nil)
      flavor1sku = Spree::Property.create({:name => "flavor1sku", :presentation => "First Flavor SKU"})
    end
    flavor2sku = Spree::Property.find_by_name("flavor2sku")
    if (flavor2sku == nil)
      flavor2sku = Spree::Property.create({:name => "flavor2sku", :presentation => "Second Flavor SKU"})
    end
    flavor3sku = Spree::Property.find_by_name("flavor3sku")
    if (flavor3sku == nil)
      flavor3sku = Spree::Property.create({:name => "flavor3sku", :presentation => "Third Flavor SKU"})
    end
    
    # setup tea profiles
    sweetness = Spree::Property.find_by_name("sweetness")
    if (sweetness == nil)
      sweetness = Spree::Property.create({:name => "sweetness", :presentation => "Sweetness"})
    end
    fruity = Spree::Property.find_by_name("fruity")
    if (fruity == nil)
      fruity = Spree::Property.create({:name => "fruity", :presentation => "Fruity"})
    end
    nutty = Spree::Property.find_by_name("nutty")
    if (nutty == nil)
      nutty = Spree::Property.create({:name => "nutty", :presentation => "Nutty"})
    end
    vegetal = Spree::Property.find_by_name("vegetal")
    if (vegetal == nil)
      vegetal = Spree::Property.create({:name => "vegetal", :presentation => "Vegetal"})
    end
    woody = Spree::Property.find_by_name("woody")
    if (woody == nil)
      woody = Spree::Property.create({:name => "woody", :presentation => "Woody"})
    end
    aroma = Spree::Property.find_by_name("aroma")
    if (aroma == nil)
      aroma = Spree::Property.create({:name => "aroma", :presentation => "Aroma"})
    end
    spicy = Spree::Property.find_by_name("spicy")
    if (spicy == nil)
      spicy = Spree::Property.create({:name => "spicy", :presentation => "Spicy"})
    end
    floral = Spree::Property.find_by_name("floral")
    if (floral == nil)
      floral = Spree::Property.create({:name => "floral", :presentation => "Floral"})
    end
    strength = Spree::Property.find_by_name("strength")
    if (strength == nil)
      strength = Spree::Property.create({:name => "strength", :presentation => "Strength"})
    end
  
  end
  
  def down 
    Spree::Property.where(:name => "flavor1name").first.destroy()
    Spree::Property.where(:name => "flavor2name").first.destroy()
    Spree::Property.where(:name => "flavor3name").first.destroy()
    Spree::Property.where(:name => "flavor1percent").first.destroy()
    Spree::Property.where(:name => "flavor2percent").first.destroy()
    Spree::Property.where(:name => "flavor3percent").first.destroy()
    Spree::Property.where(:name => "flavor1sku").first.destroy()
    Spree::Property.where(:name => "flavor2sku").first.destroy()
    Spree::Property.where(:name => "flavor3sku").first.destroy()
    Spree::Property.where(:name => "sweetness").first.destroy()
    Spree::Property.where(:name => "fruity").first.destroy()
    Spree::Property.where(:name => "nutty").first.destroy()
    Spree::Property.where(:name => "vegetal").first.destroy()
    Spree::Property.where(:name => "woody").first.destroy()
    Spree::Property.where(:name => "aroma").first.destroy()
    Spree::Property.where(:name => "spicy").first.destroy()
    Spree::Property.where(:name => "floral").first.destroy()
    Spree::Property.where(:name => "strength").first.destroy()
  end
end
  
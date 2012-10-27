Spree::ProductScope.class_eval do
  def self.all_scopes
    {
      # Scopes for selecting products based on taxon
      :taxon => {
        :taxons_name_eq => [:taxon_name],
        :in_taxons => [:taxon_names],
      },
      # product selection based on name, or search
      :search => {
        :in_name => [:words],
        :in_name_or_keywords => [:words],
        :in_name_or_description => [:words],
        :with_ids => [:ids]
      },
      # Scopes for selecting products based on option types and properties
      :values => {
        :with => [:value],
        :with_property => [:property],
        :with_property_value => [:property, :value],
        :with_option => [:option],
        :with_option_value => [:option, :value],
      },
      # product selection based upon master price
      :price => {
        :price_between => [:low, :high],
        :master_price_lte => [:amount],
        :master_price_gte => [:amount],
      },
      # product selection based upon public
      :public => {
        :ispublic => [:value],
      },
    }
  end
end
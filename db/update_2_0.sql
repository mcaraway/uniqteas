-- fix the duplicates in the spree_option_values_variants table

alter table spree_option_values_variants add column no_delete integer;

select distinct variant_id, option_value_id, 1 from spree_option_values_variants; --817 rows

insert into spree_option_values_variants (variant_id, option_value_id, no_delete) 
select distinct variant_id, option_value_id, 1 from spree_option_values_variants;
delete from spree_option_values_variants where no_delete is null;
commit;

alter table spree_option_values_variants drop column no_delete;

-- make sure there are no products without a shipping category
select * from spree_products where shipping_category_id is null;

--update any missing shipping categories
update spree_products set shipping_category_id = (select id from spree_shipping_categories where name = 'Default Shipping') where shipping_category_id is null;

-- fix shipping calculators

update spree_calculators as sc set type = updated.type 
from (
select id, concat('Spree::Calculator::Shipping', substring(type, 18, 99)) as type from spree_calculators where calculable_type = 'Spree::ShippingMethod') as updated
where sc.id = updated.id;

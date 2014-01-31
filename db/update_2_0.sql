-- fix the duplicates in the spree_option_values_variants table

alter table spree_option_values_variants add column no_delete integer;

select distinct variant_id, option_value_id, 1 from spree_option_values_variants; --817 rows

insert into spree_option_values_variants (variant_id, option_value_id, no_delete) 
select distinct variant_id, option_value_id, 1 from spree_option_values_variants;
delete from spree_option_values_variants where no_delete is null;
commit;

alter table spree_option_values_variants drop column no_delete;
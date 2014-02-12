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

-- might need to delete free shipping calculator
-- delete from spree_calculators where id = 574015691;
-- delete from spree_shipping_methods where id not in (select distinct calculable_id from spree_calculators where calculable_type = 'Spree::ShippingMethod'); 

-- fix Herbal Tea position
update spree_taxons set position = 5 where name = 'Herbal Tea';

-- adding stores
-- associate categories with main store
update spree_taxonomies set store_id = 1 where store_id is null;

-- after creating the new taxonomy in the UI need to change the permalink
update spree_taxons set permalink = 'products' where taxonomy_id = 854451442;

-- setup main taxons for store 2
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) values (558398404, 1, 'Hot Tea', 'products/hot-tea', 854451442, now(), now());
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) values (558398404, 1, 'Iced Tea', 'products/iced-tea', 854451442, now(), now());
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) values (558398404, 1, 'Teaware', 'products/accessories', 854451442, now(), now());
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) values (558398404, 1, 'User Gallery', 'products/custom-blend', 854451442, now(), now());

-- setup second level for hot-tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398405, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories') and name not in ('Iced Tea', 'Teaware', 'User Gallery') order by st.id;
-- setup Black Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398409, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/black-tea') order by st.id;
-- setup Green Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398410, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/green-tea') order by st.id;
-- setup White Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398411, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/white-tea') order by st.id;
-- setup Herbal Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398412, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/herbal-tea') order by st.id;
-- setup Fruit Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398413, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/fruit-tea') order by st.id;
-- setup Oolong Tea
insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, created_at, updated_at) select 558398414, position, name, concat('products/hot-tea/',substring(permalink,12,99)),854451442, now(), now()  from spree_taxons st where st.parent_id = (select id from spree_taxons where permalink = 'categories/oolong-tea') order by st.id;


-- associate products with main store and second store
insert into spree_products_stores select id,1 from spree_products;
insert into spree_products_stores select id,2 from spree_products;

-- assocaite products with the new taxons for root products
insert into spree_products_taxons select distinct spt.product_id, st2.id from spree_taxons st join spree_products_taxons spt on spt.taxon_id = st.id join spree_taxons st2 on st.permalink = replace(st2.permalink,'products','categories')
where st.permalink like 'categories/%' and st2.permalink like 'products/%';

-- assocaite products with the new taxons for products under hot-tea
insert into spree_products_taxons select distinct spt.product_id, st2.id from spree_taxons st join spree_products_taxons spt on spt.taxon_id = st.id join spree_taxons st2 on replace(st.permalink,'categories','products/hot-tea') = st2.permalink
where st.permalink like 'categories/%' and st2.permalink like 'products/%';

-- fix the duplicates in the spree_taxons table

alter table spree_taxons add column no_delete integer;

select distinct parent_id, position, name, permalink, taxonomy_id, icon_file_name, icon_content_type, icon_file_size, icon_updated_at, description, meta_title, meta_description, meta_keywords, depth, 1 from spree_taxons order by permalink; --817 rows

insert into spree_taxons (parent_id, position, name, permalink, taxonomy_id, icon_file_name, icon_content_type, icon_file_size, icon_updated_at, description, meta_title, meta_description, meta_keywords, depth, created_at, updated_at, no_delete) 
select distinct parent_id, position, name, permalink, taxonomy_id, icon_file_name, icon_content_type, icon_file_size, icon_updated_at, description, meta_title, meta_description, meta_keywords, depth, now(), now(), 1 from spree_taxons;
delete from spree_taxons where no_delete is null;
commit;

alter table spree_taxons drop column no_delete;
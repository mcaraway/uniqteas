-- fix the duplicates in the spree_option_values_variants table

alter table spree_option_values_variants add column no_delete integer;

select distinct variant_id, option_value_id, 1 from spree_option_values_variants; --817 rows

insert into spree_option_values_variants (variant_id, option_value_id, no_delete) 
select distinct variant_id, option_value_id, 1 from spree_option_values_variants;
delete from spree_option_values_variants where no_delete is null;
commit;

alter table spree_option_values_variants drop column no_delete;


-- fix shipping calculators

update spree_calculators as sc set type = updated.type 
from (
select id, concat('Spree::Calculator::Shipping', substring(type, 18, 99)) as type from spree_calculators where calculable_type = 'Spree::ShippingMethod') as updated
where sc.id = updated.id;

update  users as u
set     leg_count = aggr.cnt
,       leg_length = aggr.length
from    (
        select  legs.user_id
        ,       count(*) as cnt
        ,       sum(length) as length 
        from    legs 
        group by
                legs.user_id
        ) as aggr
where   u.user_id = aggr.user_id
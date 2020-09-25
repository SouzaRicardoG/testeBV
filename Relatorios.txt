--Lista BOM - 
select tube_assembly_id     
     , component_id
     , quantity
     , type
     , outside_shape
     , base_type
  from (
SELECT 'Component_01' Component
     , bom.tube_assembly_id
     , bom.component_id_1 as component_id
     , bom.quantity_1 as quantity
     , cb.type
     , cb.outside_shape
     , cb.base_type
  from bill_of_materials bom
  join comp_boss cb
    on bom.component_id_1 = cb.component_id
   and cb.component_id is not null
union
SELECT 'Component_02' Component
     , bom.tube_assembly_id
     , bom.component_id_2 as component_id
     , bom.quantity_2 as quantity
     , cb.type
     , cb.outside_shape
     , cb.base_type
  from bill_of_materials bom
  join comp_boss cb
    on bom.component_id_2 = cb.component_id
   and cb.component_id is not null
union
SELECT 'Component_03' Component
     , bom.tube_assembly_id
     , bom.component_id_3 as component_id
     , bom.quantity_3 as quantity
     , cb.type
     , cb.outside_shape
     , cb.base_type
  from bill_of_materials bom
  join comp_boss cb
    on bom.component_id_3 = cb.component_id
   and cb.component_id is not null
union 
SELECT 'Component_04' Component
     , bom.tube_assembly_id
     , bom.component_id_4 as component_id
     , bom.quantity_4 as quantity
     , cb.type
     , cb.outside_shape
     , cb.base_type
  from bill_of_materials bom
  join comp_boss cb
    on bom.component_id_4 = cb.component_id
   and cb.component_id is not null
union
SELECT 'Component_05' Component
     , bom.tube_assembly_id
     , bom.component_id_5 as component_id
     , bom.quantity_5 as quantity
     , cb.type
     , cb.outside_shape
     , cb.base_type
  from bill_of_materials bom
  join comp_boss cb
    on bom.component_id_5 = cb.component_id
   and cb.component_id is not null
     ) tbl1

where tube_assembly_id = 'TA-08070'
order by tube_assembly_id
;

--lista de cotações
SELECT bom.tube_assembly_id
     , pq.supplier
     , pq.quote_date
     , pq.annual_usage
     --, pq.min_order_quantity
     , pq.bracket_pricing
     --, pq.quantity
     , case
          when pq.bracket_pricing = 'Yes' then pq.quantity
          else pq.min_order_quantity
       end as quantity_1
     , cast(pq.cost as decimal(8,2)) as cost
     , round(
          case
             when pq.bracket_pricing = 'Yes' then
                cast(pq.cost as decimal(8,2)) * pq.quantity
             else cast(pq.cost as decimal(8,2)) * pq.min_order_quantity
          end, 2) as total_cost
       
  from bill_of_materials bom
  join price_quote pq
    on bom.tube_assembly_id = pq.tube_assembly_id

 where bom.tube_assembly_id in ('TA-05531', 'TA-00013', 'TA-00088')
;


set hive.strict.checks.cartesian.product=false; --Somente para rodar no GCP
--Lista BOM sem contacao
select bom.tube_assembly_id
  from bill_of_materials bom
 where bom.tube_assembly_id not in ( select tube_assembly_id from price_quote)
limit 100
;


--Lista de Componentes faltantes
select tbl.component_id 
  from (
SELECT bom.component_id_1 as component_id     
  from bill_of_materials bom
union
SELECT bom.component_id_2 as component_id     
  from bill_of_materials bom
union
SELECT bom.component_id_3 as component_id     
  from bill_of_materials bom
union
SELECT bom.component_id_4 as component_id     
  from bill_of_materials bom
union
SELECT bom.component_id_5 as component_id     
  from bill_of_materials bom
       ) tbl
 where tbl.component_id not in (select component_id from comp_boss)
limit 100
;
 
DROP TABLE IF EXISTS BILL_OF_MATERIALS;
CREATE TABLE BILL_OF_MATERIALS
(
 tube_assembly_id STRING,
 component_id_1   STRING,
 quantity_1       INT,
 component_id_2   STRING,
 quantity_2       INT,
 component_id_3   STRING,
 quantity_3       INT,
 component_id_4   STRING,
 quantity_4       INT,
 component_id_5   STRING,
 quantity_5       INT,
 component_id_6   STRING,
 quantity_6       INT,
 component_id_7   STRING,
 quantity_7       INT,
 component_id_8   STRING,
 quantity_8       INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES("skip.header.line.count"="1");
;
LOAD DATA LOCAL INPATH '/home/maria_dev/testeBV/bill_of_materials.csv' into table BILL_OF_MATERIALS;

DROP TABLE IF EXISTS COMP_BOSS;
CREATE TABLE COMP_BOSS
(
 component_id STRING,
 component_type_id STRING,
 type STRING,
 connection_type_id STRING,
 outside_shape STRING,
 base_type STRING,
 height_over_tube DOUBLE,
 bolt_pattern_long DOUBLE,
 bolt_pattern_wide DOUBLE,
 groove STRING,
 base_diameter DOUBLE,
 shoulder_diameter DOUBLE,
 unique_feature STRING,
 orientation STRING,
 weight DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES("skip.header.line.count"="1");
;
LOAD DATA LOCAL INPATH '/home/maria_dev/testeBV/comp_boss.csv' into table COMP_BOSS;

DROP TABLE IF EXISTS PRICE_QUOTE;
CREATE TABLE PRICE_QUOTE
(
 tube_assembly_id   STRING,
 supplier           STRING,
 quote_date         STRING,
 annual_usage       INT,
 min_order_quantity INT,
 bracket_pricing    STRING,
 quantity           INT,
 cost               DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
TBLPROPERTIES("skip.header.line.count"="1");
;
LOAD DATA LOCAL INPATH '/home/maria_dev/testeBV/price_quote.csv' into table PRICE_QUOTE;


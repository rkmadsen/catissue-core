LOAD DATA INFILE 'H://caTissue//work//workspace//catissuecoreNew/SQL/DBUpgrade/Common/CAModelCSVs/DYEXTN_PRIMITIVE_ATTRIBUTE.csv' 
APPEND 
INTO TABLE DYEXTN_PRIMITIVE_ATTRIBUTE 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(IDENTIFIER NULLIF IDENTIFIER='\\N',IS_COLLECTION NULLIF IS_COLLECTION='\\N',IS_IDENTIFIED NULLIF IS_IDENTIFIED='\\N',IS_PRIMARY_KEY NULLIF IS_PRIMARY_KEY='\\N',IS_NULLABLE NULLIF IS_NULLABLE='\\N')
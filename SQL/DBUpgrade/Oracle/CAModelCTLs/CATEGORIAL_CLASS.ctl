LOAD DATA INFILE 'H://caTissue//work//workspace//catissuecoreNew/SQL/DBUpgrade/Common/CAModelCSVs/CATEGORIAL_CLASS.csv' 
APPEND 
INTO TABLE CATEGORIAL_CLASS 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(ID NULLIF ID='\\N',DE_ENTITY_ID NULLIF DE_ENTITY_ID='\\N',PATH_FROM_PARENT_ID NULLIF PATH_FROM_PARENT_ID='\\N',PARENT_CATEGORIAL_CLASS_ID NULLIF PARENT_CATEGORIAL_CLASS_ID='\\N')
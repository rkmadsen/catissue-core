LOAD DATA INFILE 'H://caTissue//work//workspace//catissuecoreNew/SQL/DBUpgrade/Common/CAModelCSVs/DYEXTN_RULE.csv' 
APPEND 
INTO TABLE DYEXTN_RULE 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(IDENTIFIER NULLIF IDENTIFIER='\\N',NAME NULLIF NAME='\\N',ATTRIBUTE_ID NULLIF ATTRIBUTE_ID='\\N')
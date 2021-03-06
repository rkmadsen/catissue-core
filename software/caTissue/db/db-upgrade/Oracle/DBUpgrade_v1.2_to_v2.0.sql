-- To add unique constraint for Bugid:19485
-- alter table CSM_MIGRATE_USER add constraint MIG_USR_KEY unique (TARGET_IDP_NAME, MIGRATED_LOGIN_NAME)
/
-- Required for model changes
alter table CATISSUE_PATHOLOGY_REPORT add SCG_ID NUMBER(19)
/
alter table CATISSUE_PATHOLOGY_REPORT add constraint fk_scgid foreign key(SCG_ID) references CATISSUE_SPECIMEN_COLL_GROUP(IDENTIFIER)
/
alter table CATISSUE_SPECIMEN_COLL_GROUP add DSPR_ID NUMBER(19)
/
alter table CATISSUE_SPECIMEN_COLL_GROUP add ISPR_ID NUMBER(19)
/
alter table CATISSUE_SPECIMEN_COLL_GROUP add constraint fk_dspr_id foreign key(DSPR_ID) references CATISSUE_DEIDENTIFIED_REPORT(IDENTIFIER)
/
alter table CATISSUE_SPECIMEN_COLL_GROUP add constraint fk_ispr_id foreign key(ISPR_ID) references CATISSUE_IDENTIFIED_REPORT(IDENTIFIER)
/
create or replace PROCEDURE CACORE_UPGRADE_PROC AS
BEGIN
  DECLARE
  CURSOR ispr_cur IS
	SELECT scg_id, ispr.IDENTIFIER
	FROM catissue_identified_report ispr, catissue_specimen_coll_group scg
	WHERE scg.IDENTIFIER= ispr.scg_id;

  CURSOR dspr_cur IS
	SELECT scg_id, dspr.IDENTIFIER
	FROM catissue_deidentified_report dspr, catissue_specimen_coll_group scg
	WHERE scg.IDENTIFIER=dspr.scg_id;

	scgId NUMBER;
	isprId NUMBER;
	dsprId NUMBER;

	BEGIN
	OPEN ispr_cur;
		FETCH ispr_cur INTO scgId, isprId;
		LOOP
			IF ispr_cur%NOTFOUND THEN
				EXIT;
			END IF;

			UPDATE catissue_pathology_report
			SET SCG_ID = scgId
			WHERE IDENTIFIER = isprId;

			UPDATE catissue_specimen_coll_group
			SET ISPR_ID = isprId
			WHERE IDENTIFIER = scgId;

			FETCH ispr_cur into scgId, isprId;
		END LOOP;
	CLOSE ispr_cur;

	OPEN dspr_cur;
		FETCH dspr_cur INTO scgId, dsprId;
		LOOP
			IF dspr_cur%NOTFOUND THEN
				EXIT;
			END IF;

			UPDATE catissue_pathology_report
			SET SCG_ID = scgId
			WHERE IDENTIFIER = dsprId;

			UPDATE catissue_specimen_coll_group
			SET DSPR_ID = dsprId
			WHERE IDENTIFIER = scgId;

			FETCH dspr_cur into scgId, dsprId;
		END LOOP;
	CLOSE dspr_cur;

	commit;
	END;
END CACORE_UPGRADE_PROC;
/
begin
 cacore_upgrade_proc();
end;
/
drop procedure "CACORE_UPGRADE_PROC"
/
alter table catissue_identified_report drop column "SCG_ID"
/
alter table catissue_deidentified_report drop column "SCG_ID"
/

-- These SQL's are for creating SPP related tables and coresponding changes in the model for SPP
create table catissue_spp (IDENTIFIER number(19,0), NAME varchar(150) unique, BARCODE varchar(50) unique,spp_template_xml CLOB,  primary key (IDENTIFIER))
/
create table catissue_abstract_application (IDENTIFIER number(19,0), REASON_DEVIATION varchar(4000), TIMESTAMP timestamp, USER_DETAILS number(19,0), COMMENTS varchar(4000), primary key (IDENTIFIER), foreign key (USER_DETAILS) references catissue_user (IDENTIFIER))
/
create table catissue_default_action (IDENTIFIER number(19,0), PRIMARY KEY (IDENTIFIER), foreign key (IDENTIFIER) references dyextn_abstract_form_context (IDENTIFIER))
/
create table catissue_spp_application (IDENTIFIER number(19,0), SPP_IDENTIFIER number(19,0), SCG_IDENTIFIER number(19,0), primary key (IDENTIFIER), foreign key (IDENTIFIER) references  catissue_abstract_application (IDENTIFIER) ,foreign key (SPP_IDENTIFIER) references catissue_spp (IDENTIFIER), foreign key (SCG_IDENTIFIER) references catissue_specimen_coll_group (IDENTIFIER))
/
create table catissue_action_application (IDENTIFIER number(19,0), SPP_APP_IDENTIFIER number(19,0), SPECIMEN_ID number(19,0), SCG_ID number(19,0), primary key (IDENTIFIER), foreign key (IDENTIFIER) references catissue_abstract_application (IDENTIFIER), foreign key (SPP_APP_IDENTIFIER) references catissue_spp_application (IDENTIFIER), foreign key (SPECIMEN_ID) references catissue_specimen (IDENTIFIER), foreign key (SCG_ID) references catissue_specimen_coll_group (IDENTIFIER))
/
create table catissue_action_app_rcd_entry (IDENTIFIER number(19,0), ACTION_APP_ID number(19,0), primary key (IDENTIFIER), foreign key (ACTION_APP_ID) references catissue_action_application (IDENTIFIER))
/
create table catissue_action (IDENTIFIER number(19,0), BARCODE varchar(50), ACTION_ORDER number(19,0), ACTION_APP_RECORD_ENTRY_ID number(19,0), SPP_IDENTIFIER number(19,0), UNIQUE_ID varchar(50) not null, IS_SKIPPED number(1,0) default 0, primary key (IDENTIFIER), foreign key (ACTION_APP_RECORD_ENTRY_ID) references catissue_action_app_rcd_entry (IDENTIFIER), foreign key (SPP_IDENTIFIER) references catissue_spp (IDENTIFIER))
/
ALTER TABLE catissue_action ADD CONSTRAINT spp_unique_id UNIQUE (SPP_IDENTIFIER,UNIQUE_ID)
/
create table catissue_cpe_spp (cpe_identifier number(19,0), spp_identifier number(19,0),CONSTRAINT catissue_cpe_spp_1 FOREIGN KEY (cpe_identifier) REFERENCES catissue_coll_prot_event (IDENTIFIER),CONSTRAINT catissue_cpe_spp_2 FOREIGN KEY (spp_identifier) REFERENCES catissue_spp (IDENTIFIER))
/
alter table catissue_action_application add (ACTION_IDENTIFIER number(19,0), ACTION_APP_RECORD_ENTRY_ID number(19,0), foreign key (ACTION_IDENTIFIER) references catissue_action (IDENTIFIER), foreign key (ACTION_APP_RECORD_ENTRY_ID) references catissue_action_app_rcd_entry (IDENTIFIER))
/
alter table catissue_cp_req_specimen add (SPP_IDENTIFIER number(19,0), ACTION_IDENTIFIER number(19,0), foreign key (SPP_IDENTIFIER) references catissue_spp (IDENTIFIER), foreign key (ACTION_IDENTIFIER) references catissue_action (IDENTIFIER))
/
alter table catissue_specimen add (SPP_APPLICATION_ID number(19,0), ACTION_APPLICATION_ID number(19,0), foreign key (SPP_APPLICATION_ID) references catissue_spp_application (IDENTIFIER), foreign key (ACTION_APPLICATION_ID) references catissue_action_application (IDENTIFIER))
/
create sequence CATISSUE_ABS_APPL_SEQ
/
create sequence CATISSUE_SPP_SEQ
/
-- SQL's for SPP tables creation end

--SQL's for inserting SPP metadata for simple search
INSERT INTO CATISSUE_QUERY_TABLE_DATA(TABLE_ID, TABLE_NAME, DISPLAY_NAME, ALIAS_NAME, PRIVILEGE_ID, FOR_SQI)  VALUES(103,'catissue_spp','Specimen Processing Procedure','SpecimenProcessingProcedure',2,1)
/
INSERT INTO CATISSUE_TABLE_RELATION( RELATIONSHIP_ID, PARENT_TABLE_ID, CHILD_TABLE_ID) VALUES(148,103,103)
/
INSERT INTO CATISSUE_INTERFACE_COLUMN_DATA( IDENTIFIER, TABLE_ID, COLUMN_NAME , ATTRIBUTE_TYPE ) VALUES(346,103,'IDENTIFIER', 'bigint')
/
INSERT INTO CATISSUE_SEARCH_DISPLAY_DATA (RELATIONSHIP_ID, COL_ID, DISPLAY_NAME, DEFAULT_VIEW_ATTRIBUTE, ATTRIBUTE_ORDER) VALUES ( (select max(RELATIONSHIP_ID) FROM CATISSUE_TABLE_RELATION), (SELECT max(IDENTIFIER) FROM CATISSUE_INTERFACE_COLUMN_DATA), 'Identifier',1,1)
/
INSERT INTO CATISSUE_INTERFACE_COLUMN_DATA( IDENTIFIER, TABLE_ID, COLUMN_NAME , ATTRIBUTE_TYPE ) VALUES(347,103,'NAME', 'varchar')
/
INSERT INTO CATISSUE_QUERY_EDITLINK_COLS VALUES((SELECT max(TABLE_ID) FROM CATISSUE_QUERY_TABLE_DATA), (SELECT max(IDENTIFIER) FROM CATISSUE_INTERFACE_COLUMN_DATA))
/
INSERT INTO CATISSUE_SEARCH_DISPLAY_DATA (RELATIONSHIP_ID, COL_ID, DISPLAY_NAME, DEFAULT_VIEW_ATTRIBUTE, ATTRIBUTE_ORDER) VALUES ((select max(RELATIONSHIP_ID) FROM CATISSUE_TABLE_RELATION), (SELECT max(IDENTIFIER) FROM CATISSUE_INTERFACE_COLUMN_DATA), 'SPP Name',1,2)
/
INSERT INTO CATISSUE_INTERFACE_COLUMN_DATA( IDENTIFIER, TABLE_ID, COLUMN_NAME , ATTRIBUTE_TYPE ) VALUES(348,103,'BARCODE', 'varchar')
/
INSERT INTO CATISSUE_SEARCH_DISPLAY_DATA (RELATIONSHIP_ID, COL_ID, DISPLAY_NAME, DEFAULT_VIEW_ATTRIBUTE, ATTRIBUTE_ORDER) VALUES ((select max(RELATIONSHIP_ID) FROM CATISSUE_TABLE_RELATION), (SELECT max(IDENTIFIER) FROM CATISSUE_INTERFACE_COLUMN_DATA), 'Barcode',1,3)
/
-- SQLs for Grid Grouper integration
create table CATISSUE_CP_GRID_PRVG (
   IDENTIFIER NUMBER(20) NOT NULL,
   GROUP_NAME VARCHAR2(255) NOT NULL,
   STEM_NAME VARCHAR2(255) NOT NULL,
   PRIVILEGES_STRING VARCHAR2(255),
   STATUS VARCHAR2(255),
   COLLECTION_PROTOCOL_ID number(19,0) NOT NULL,
   primary key (IDENTIFIER),
   CONSTRAINT FK_GRID_GRP_COLPROT FOREIGN KEY (COLLECTION_PROTOCOL_ID) REFERENCES CATISSUE_COLLECTION_PROTOCOL (IDENTIFIER)
)
/
create sequence CATISSUE_CP_GRID_PRVG_SEQ
/
-- SQLs for Grid Grouper integration end
-- SQLs to make GSID querieable
INSERT INTO CATISSUE_INTERFACE_COLUMN_DATA( IDENTIFIER, TABLE_ID, COLUMN_NAME , ATTRIBUTE_TYPE ) VALUES(349,33,'GLOBAL_SPECIMEN_IDENTIFIER', 'varchar')
/
INSERT INTO CATISSUE_SEARCH_DISPLAY_DATA (RELATIONSHIP_ID, COL_ID, DISPLAY_NAME, DEFAULT_VIEW_ATTRIBUTE, ATTRIBUTE_ORDER) VALUES ((select RELATIONSHIP_ID FROM CATISSUE_TABLE_RELATION WHERE PARENT_TABLE_ID = (SELECT TABLE_ID FROM CATISSUE_QUERY_TABLE_DATA WHERE TABLE_NAME = 'CATISSUE_SPECIMEN') AND CHILD_TABLE_ID = (SELECT TABLE_ID FROM CATISSUE_QUERY_TABLE_DATA WHERE TABLE_NAME = 'CATISSUE_SPECIMEN')), (SELECT max(IDENTIFIER) FROM CATISSUE_INTERFACE_COLUMN_DATA), 'GSID',1,3)
/
-- SQLs to make GSID querieable ends
/
-- Changes For SCG Age AT Collection 
ALTER TABLE catissue_specimen_coll_group ADD (AGE_AT_COLLECTION NUMBER(6,2))
/
-- For Update Encounter Time Stamp:
	UPDATE catissue_specimen_coll_group scg 
	set ENCOUNTER_TIMESTAMP =
	(select max(EVENT_TIMESTAMP) from catissue_specimen_event_param sep,
	catissue_coll_event_param cep
	where sep.SPECIMEN_COLL_GRP_ID = scg.identifier and
	sep.identifier = cep.identifier
	)
/
-- For Update Encounter Time Stamp:
	UPDATE catissue_specimen_coll_group scg
	set AGE_AT_COLLECTION=(select round(((scg.ENCOUNTER_TIMESTAMP-part.BIRTH_DATE)/365),0)
		from catissue_coll_prot_reg cpr ,catissue_participant part
		where scg.COLLECTION_PROTOCOL_REG_ID=cpr.identifier
			AND
		part.identifier=cpr.PARTICIPANT_ID
		AND
		part.BIRTH_DATE IS NOT NULL
		AND
		scg.ENCOUNTER_TIMESTAMP IS NOT NULL
	)
/
Alter table QUERY_PARAMETERIZED_QUERY add SHOW_TREE number(1,0) default 0
/
Alter table CATISSUE_SPECIMEN_EVENT_PARAM add ACTIVITY_STATUS varchar2(50) default 'Active'
/
 Insert into catissue_permissible_value(Identifier,PARENT_IDENTIFIER,VALUE) select (select max(identifier)+1 from catissue_permissible_value), 3,'Buffy Coat' from dual where not exists (select * from catissue_permissible_value where PARENT_IDENTIFIER=3 and (Value like 'Buffy Coat' or Value like 'buffy coat'))
/
create or replace
PROCEDURE update_SYS_UID IS
  maxLabelSpecimen number(19);
 sys_uid_counter number(19);
 ident number(19);
 BEGIN
   ident:=0;
 
  select cast(MAX(CATISSUE_LABEL_TO_NUM(LABEL)) as number(19))+1  into maxLabelSpecimen from catissue_specimen;

  select NVL(max(cast(KEY_SEQUENCE_ID as number(19))),0) into sys_uid_counter from key_seq_generator where KEY_VALUE='SYS_UID';
  
  Select cast(NVL(max(identifier),0) as number(19)) into ident from key_seq_generator;
  
  ident:=ident + 1;
  
IF (sys_uid_counter=0) THEN
 
 INSERT INTO key_seq_generator VALUES(ident,'SYS_UID',cast(maxLabelSpecimen as varchar(19)),'Specimen');
  
ELSE
  
  IF (sys_uid_counter < maxLabelSpecimen) THEN
   
    update key_seq_generator set KEY_SEQUENCE_ID=cast(maxLabelSpecimen as varchar(19)) where KEY_VALUE='SYS_UID';
  
  END IF;

END IF;

END update_SYS_UID;
/
begin
 update_SYS_UID();
end;
/
update (
select meta.name from dyextn_abstract_metadata source join dyextn_attribute attr on source.identifier = attr.entiy_id 
join dyextn_association assoc on assoc.identifier  = attr.identifier join dyextn_abstract_metadata target 
on target.identifier = assoc.target_entity_id and source.name ='edu.wustl.catissuecore.domain.deintegration.ParticipantRecordEntry' 
and target.name='edu.wustl.catissuecore.domain.Participant' join dyextn_abstract_metadata meta on meta.identifier= assoc.identifier 
)temp
set temp.name='participantRecordEntryCollection'
/

create table temp_spp_events (collection_procedure varchar(200), container varchar(200),received_quality varchar(200),spp_id number(19,0))
/
create sequence CATISSUE_temp_SPP_SEQ
/

CREATE GLOBAL TEMPORARY TABLE temp_events (
    sr_id     NUMBER(19, 0), 
    procedure VARCHAR2(50), 
    container VARCHAR2 (50), 
    quality     VARCHAR2 (255), 
    PRIMARY KEY(sr_id))
/

INSERT INTO temp_events (sr_id, procedure, container)
(
SELECT
    distinct specreq.identifier,coll.collection_procedure,coll.container
FROM
    catissue_coll_event_param coll,
    catissue_specimen_event_param event_param,
    catissue_cp_req_specimen specreq,
    catissue_coll_prot_event cpe
WHERE
    coll.identifier = event_param.identifier and
    specreq.identifier = event_param.specimen_id and
    specreq.collection_protocol_event_id = cpe.identifier
)
/

insert into temp_spp_events(collection_procedure,container,received_quality)
(
SELECT 
    distinct temp_events.procedure, temp_events.container, rec.received_quality
FROM
    temp_events temp_events,
    catissue_received_event_param rec,    
    catissue_specimen_event_param event_param,
    catissue_cp_req_specimen specreq,
    catissue_coll_prot_event cpe
WHERE
    temp_events.sr_id = specreq.identifier and
    specreq.collection_protocol_event_id = cpe.identifier and
    specreq.identifier = event_param.specimen_id and        
    rec.identifier = event_param.identifier)
/

DROP TABLE temp_events
/
ALTER TABLE catissue_disposal_event_param MODIFY (REASON varchar2(2000))
/
update dyextn_database_properties set name = 'ISPR_ID' where identifier in ( 
select column_prop.identifier from dyextn_column_properties column_prop join 
dyextn_constraintkey_prop cnstrKeyProp on cnstrKeyProp.identifier = column_prop.cnstr_key_prop_id join 
 dyextn_constraint_properties cnstr_prop on cnstrKeyProp.src_constraint_key_id = cnstr_prop.identifier join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.IdentifiedSurgicalPathologyReport')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
update dyextn_database_properties set name = 'ISPR_ID' where identifier in ( 
select column_prop.identifier from dyextn_column_properties column_prop join 
dyextn_constraintkey_prop cnstrKeyProp on cnstrKeyProp.identifier = column_prop.cnstr_key_prop_id join 
 dyextn_constraint_properties cnstr_prop on cnstrKeyProp.tgt_constraint_key_id = cnstr_prop.identifier join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.IdentifiedSurgicalPathologyReport')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id)
/
update dyextn_database_properties set name = 'DSPR_ID' where identifier in ( 
select column_prop.identifier from dyextn_column_properties column_prop join 
dyextn_constraintkey_prop cnstrKeyProp on cnstrKeyProp.identifier = column_prop.cnstr_key_prop_id join 
 dyextn_constraint_properties cnstr_prop on cnstrKeyProp.src_constraint_key_id = cnstr_prop.identifier join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.DeidentifiedSurgicalPathologyReport')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
update dyextn_database_properties set name = 'DSPR_ID' where identifier in ( 
select column_prop.identifier from dyextn_column_properties column_prop join 
dyextn_constraintkey_prop cnstrKeyProp on cnstrKeyProp.identifier = column_prop.cnstr_key_prop_id join 
 dyextn_constraint_properties cnstr_prop on cnstrKeyProp.tgt_constraint_key_id = cnstr_prop.identifier join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.DeidentifiedSurgicalPathologyReport')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id)
/
update dyextn_constraintkey_prop  set TGT_CONSTRAINT_KEY_ID = SRC_CONSTRAINT_KEY_ID , SRC_CONSTRAINT_KEY_ID = null where SRC_CONSTRAINT_KEY_ID in (
select cnstr_prop.identifier from dyextn_constraint_properties cnstr_prop  join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.IdentifiedSurgicalPathologyReport')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
update dyextn_constraintkey_prop  set TGT_CONSTRAINT_KEY_ID = SRC_CONSTRAINT_KEY_ID , SRC_CONSTRAINT_KEY_ID = null where SRC_CONSTRAINT_KEY_ID in (
select cnstr_prop.identifier from dyextn_constraint_properties cnstr_prop  join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.DeidentifiedSurgicalPathologyReport')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
update dyextn_constraintkey_prop  set SRC_CONSTRAINT_KEY_ID = TGT_CONSTRAINT_KEY_ID , TGT_CONSTRAINT_KEY_ID = null where TGT_CONSTRAINT_KEY_ID in (
select cnstr_prop.identifier from dyextn_constraint_properties cnstr_prop  join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.DeidentifiedSurgicalPathologyReport')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
update dyextn_constraintkey_prop  set SRC_CONSTRAINT_KEY_ID = TGT_CONSTRAINT_KEY_ID , TGT_CONSTRAINT_KEY_ID = null where TGT_CONSTRAINT_KEY_ID in (
select cnstr_prop.identifier from dyextn_constraint_properties cnstr_prop  join  
(select association.identifier from dyextn_association association, dyextn_attribute attribute  where association.Target_Entity_id in (select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.pathology.IdentifiedSurgicalPathologyReport')
and attribute.Entiy_id in ( select identifier from DYEXTN_ABSTRACT_METADATA where name like 'edu.wustl.catissuecore.domain.SpecimenCollectionGroup')
and attribute.identifier = association.identifier) associationid on associationid.identifier = cnstr_prop.association_id )
/
commit
/
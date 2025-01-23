CREATE OR REPLACE PACKAGE TBLACK.sc_scriptexecuter IS

function getVersion return number;

function getDDL(in_schema_cd varchar2, in_type_cd varchar2, in_name_tx varchar2, in_collation_tx varchar2, in_schemaprefix_yn varchar2) return clob;
function getHardObjectDDL(in_schema_cd varchar2, in_type_cd varchar2, in_name_tx varchar2,in_storage_yn varchar2,in_segment_yn varchar2,in_tablespace_yn varchar2,
                     in_consAsAlter_yn varchar2,in_oid_yn varchar2,in_sizebyte_yn varchar2,in_partition_yn varchar2,in_lobstorage_tx varchar2, 
                     in_compression_tx varchar2, in_pctspace_nr number, in_collation_tx varchar2,in_schemaprefix_yn varchar2) return clob;

END;
/

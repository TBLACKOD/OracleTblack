CREATE OR REPLACE PACKAGE BODY TBLACK.sc_scriptexecuter IS

function getVersion return number is
begin
  return 109;
end;

procedure dummy(in_tx varchar2:=null,in_cl clob:=null) is
pragma autonomous_transaction;
begin
  commit;
end;

function qualifyBaseObject(in_cl clob, in_schema_cd varchar2) return clob is
  v_endOfOn_nr number;
  --v_newDDL_cl clob;
  v_restOfDDL_cl clob;
  v_firstChar_nr number;
  v_firstNonChar_nr number;
  v_cl clob;
  v_original_cl clob;
  v_restOfOriginal_cl clob;
begin
  v_cl:=in_cl;
  v_original_cl:=in_cl;
  v_cl:=replace(v_cl,chr(10),' ');
  v_cl:=replace(v_cl,chr(13),' ');
  v_cl:=replace(v_cl,chr(9),' ');
  v_cl:=replace(v_cl,chr(32),' ');
  v_endOfOn_nr:=regexp_instr(v_cl,' ON ',1,1,1,'i')-1;
  --v_newDDL_cl:=substr(v_cl,1,v_endOfOn_nr);
  v_restOfDDL_cl:=substr(v_cl,v_endOfOn_nr);
  v_restOfOriginal_cl:=substr(v_original_cl,v_endOfOn_nr);
  v_firstChar_nr:=regexp_instr(v_restOfDDL_cl,'[[:alpha:]]',1,1,0,'i');
  v_firstNonChar_nr:=regexp_instr(v_restOfDDL_cl,'\.|\ ',v_firstChar_nr,1,0,'i');
  if substr(v_restOfDDL_cl,v_firstNonChar_nr,1)='.' then
    --fs_debug.log('QUALIFYBASEOBJECT:1:v_firstNonChar_nr='||v_firstNonChar_nr,v_restOfDDL_cl);
    if DBMS_DB_VERSION.VERSION<19 then
      dummy('x',v_restOfDDL_cl);
    end if;  
    return v_original_cl;
  else
    --fs_debug.log('QUALIFYBASEOBJECT:2:v_endofOn_nr='||v_endofOn_nr||', in_schema_cd='||in_schema_cd||',v_firstChar_nr='||v_firstChar_nr,v_restOfOriginal_cl);
    --fs_debug.log('QUALIFYBASEOBJECT:3:v_original_cl',v_original_cl);
    if substr(v_restOfDDL_cl,v_firstChar_nr,9)='DATABASE ' then
      return in_cl;
    end if;    
    if substr(v_restOfDDL_cl,v_firstChar_nr-1,1)='"' then
      return substr(v_original_cl,1,v_endofOn_nr)||' '||in_schema_cd||'."'||substr(v_restOfOriginal_cl,v_firstChar_nr);
    else  
      return substr(v_original_cl,1,v_endofOn_nr)||' '||in_schema_cd||'.'||substr(v_restOfOriginal_cl,v_firstChar_nr);
    end if;  
  end if;
end;

function removeBaseObject(in_cl clob, in_schema_cd varchar2) return clob is
  v_endOfOn_nr number;
  --v_newDDL_cl clob;
  v_restOfDDL_cl clob;
  v_firstChar_nr number;
  v_firstNonChar_nr number;
  v_cl clob;
  v_original_cl clob;
  v_restOfOriginal_cl clob;
begin
  v_cl:=in_cl;
  v_original_cl:=in_cl;
  v_cl:=replace(v_cl,chr(10),' ');
  v_cl:=replace(v_cl,chr(13),' ');
  v_cl:=replace(v_cl,chr(9),' ');
  v_cl:=replace(v_cl,chr(32),' ');
  v_endOfOn_nr:=regexp_instr(v_cl,' ON ',1,1,1,'i')-1;
  --v_newDDL_cl:=substr(v_cl,1,v_endOfOn_nr);
  v_restOfDDL_cl:=substr(v_cl,v_endOfOn_nr);
  v_restOfOriginal_cl:=substr(v_original_cl,v_endOfOn_nr);
  v_firstChar_nr:=regexp_instr(v_restOfDDL_cl,'[[:alpha:]]',1,1,0,'i');
  v_firstNonChar_nr:=regexp_instr(v_restOfDDL_cl,'\.|\ ',v_firstChar_nr,1,0,'i');
  if DBMS_DB_VERSION.VERSION<19 then
    dummy('x',v_restOfDDL_cl);
  end if;
  if substr(v_restOfDDL_cl,v_firstNonChar_nr,1)='.' then
    return substr(v_original_cl,1,v_endofOn_nr)||' '||substr(v_restOfOriginal_cl,v_firstNonChar_nr+1);
  else  
    return v_original_cl;
  end if;  
end;

function qualifyBaseObjectSynonym(in_cl clob, in_schema_cd varchar2) return clob is
  v_endOfOn_nr number;

  v_restOfDDL_cl clob;
  v_firstChar_nr number;
  v_firstNonChar_nr number;
  v_cl clob;
  v_original_cl clob;
  v_restOfOriginal_cl clob;
  v_return_cl clob;
begin
  v_cl:=in_cl;
  v_original_cl:=in_cl;
  v_cl:=replace(v_cl,chr(10),' ');
  v_cl:=replace(v_cl,chr(13),' ');
  v_cl:=replace(v_cl,chr(9),' ');
  v_cl:=replace(v_cl,chr(32),' ');
  v_endOfOn_nr:=regexp_instr(v_cl,' FOR ',1,1,1,'i')-1;

  v_restOfDDL_cl:=substr(v_cl,v_endOfOn_nr);
  v_restOfOriginal_cl:=substr(v_original_cl,v_endOfOn_nr);
  v_firstChar_nr:=regexp_instr(v_restOfDDL_cl,'[[:alpha:]]',1,1,0,'i');
  v_firstNonChar_nr:=regexp_instr(v_restOfDDL_cl,'\.|\ ',v_firstChar_nr,1,0,'i');
  if substr(v_restOfDDL_cl,v_firstNonChar_nr,1)='.' then
    select v_original_cl into v_return_cl
    from dual;
  else
    if substr(v_restOfDDL_cl,v_firstChar_nr-1,1)='"' then
      select substr(v_original_cl,1,v_endofOn_nr)||' '||in_schema_cd||'."'||substr(v_restOfOriginal_cl,v_firstChar_nr) into v_return_cl
      from dual;
    else  
      select substr(v_original_cl,1,v_endofOn_nr)||' '||in_schema_cd||'.'||substr(v_restOfOriginal_cl,v_firstChar_nr) into v_return_cl
      from dual;
    end if;  
  end if;
  return v_return_cl;
end;

function getOtherDDL(in_schema_cd varchar2, in_type_cd varchar2, in_name_tx varchar2, in_schemaprefix_yn varchar2) return clob is
 h number;
 th number;
 v_cl clob;
begin
  h:=dbms_metadata.open(in_type_cd);
  dbms_metadata.set_filter(h,'SCHEMA',in_schema_cd);
  dbms_metadata.set_filter(h,'NAME',in_name_tx);
  th:=dbms_metadata.add_transform(h,'MODIFY');
  --dbms_metadata.set_remap_param(th,'REMAP_SCHEMA',in_schema_cd,'');
  th:=dbms_metadata.add_transform(h,'DDL');
  begin
    if in_schemaprefix_yn='Y' or in_schemaprefix_yn is null then
      dbms_metadata.set_transform_param(th,'EMIT_SCHEMA',true);
    elsif in_schemaprefix_yn='N' then
      dbms_metadata.set_transform_param(th,'EMIT_SCHEMA',false);
    end if;
  exception
    when others then
      null;
  end;      
  v_cl:=dbms_metadata.fetch_clob(h);
  dbms_metadata.close(h);
  v_cl := rtrim(rtrim(v_cl),chr(10));
  v_cl := ltrim(ltrim(v_cl,chr(10)));
  return v_cl;
end;

function isInsteadOfTrigger(in_cl clob) return varchar2 is
  v_endOfOn_nr number;
  v_endOfInsteadOf_nr number;
begin
  v_endOfOn_nr:=regexp_instr(in_cl,' ON ',1,1,1,'i')-1;
  v_endOfInsteadOf_nr:=regexp_instr(in_cl,'INSTEAD OF',1,1,1,'i')-1;
  if v_endOfinsteadOf_nr>0 and v_endOfinsteadOf_nr<v_endOfOn_nr then
    return 'Y';
  else
    return 'N';
  end if;
end;

function getHardObjectDDL(in_schema_cd varchar2, in_type_cd varchar2, in_name_tx varchar2,in_storage_yn varchar2,in_segment_yn varchar2,in_tablespace_yn varchar2,
                     in_consAsAlter_yn varchar2,in_oid_yn varchar2,in_sizebyte_yn varchar2,in_partition_yn varchar2,in_lobstorage_tx varchar2, 
                     in_compression_tx varchar2, in_pctspace_nr number, in_collation_tx varchar2, in_schemaprefix_yn varchar2) return clob is
  v_originalDDL_cl clob;
  v_cl clob;
begin
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'DEFAULT',true);
  
  begin
    if in_schemaprefix_yn='Y' or in_schemaprefix_yn is null then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',true);
    elsif in_schemaprefix_yn='N' then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',false);
    end if;
  exception
    when others then
      null;
  end;  
  
  dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
  begin
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'COLLATION_CLAUSE',in_collation_tx);
  exception
    when others then
      null;
  end;
  if in_storage_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
  end if;
  if in_segment_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
  end if;
  if in_tablespace_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
  end if;
  if in_consAsAlter_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'CONSTRAINTS_AS_ALTER',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'CONSTRAINTS_AS_ALTER',false);
  end if;
  if in_oid_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'OID',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'OID',false);
  end if;
  if in_sizebyte_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SIZE_BYTE_KEYWORD',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SIZE_BYTE_KEYWORD',false);
  end if;
  if in_partition_yn='Y' then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PARTITIONING',true);
  else
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PARTITIONING',false);
  end if;
  if in_lobstorage_tx is not null and DBMS_DB_VERSION.VERSION>11 then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'LOB_STORAGE',in_lobstorage_tx);
  end if;
  if in_compression_tx is not null then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLE_COMPRESSION_CLAUSE',in_compression_tx);
  end if;
  if in_pctspace_nr is not null then
    dbms_metadata.set_transform_param(dbms_metadata.session_transform,'PCTSPACE',in_pctspace_nr);
  end if;
  v_originalDDL_cl := dbms_metadata.get_ddl(in_type_cd, in_name_tx,in_schema_cd);
  v_cl := v_originalDDL_cl;
  v_cl := rtrim(rtrim(v_cl),chr(10));
  v_cl := ltrim(ltrim(v_cl,chr(10)));
  return v_cl;
exception
  when others then
    return null;  
end;

function getDDL(in_schema_cd varchar2, in_type_cd varchar2, in_name_tx varchar2, in_collation_tx varchar2, in_schemaprefix_yn varchar2) return clob is
  v_cl clob;
  v_originalDDL_cl clob;
  v_type_cd varchar2(200);
  v_regExpSpecialChars_tx varchar2(255) := '([][)(}{.$*+?,|^\])';
  v_insteadOf_yn varchar2(1):='N';
begin

    if in_type_cd not in ('PACKAGE BODY','PACKAGE','TYPE BODY','TYPE','TRIGGER','SYNONYM','PROCEDURE','FUNCTION','VIEW') then
      return getOtherDDL(in_schema_cd, in_type_cd, in_name_tx, in_schemaprefix_yn);
    end if;
    if in_type_cd='PACKAGE BODY' then
      v_type_cd:='PACKAGE';
    elsif in_type_cd='TYPE BODY' then
      v_type_cd:='TYPE';
    else
      v_type_cd:=in_type_cd;
    end if;

    begin
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'COLLATION_CLAUSE',in_collation_tx);
    exception
      when others then
        null;
    end;

    begin
      if in_schemaprefix_yn='Y' or in_schemaprefix_yn is null then
        dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',true);
      elsif in_schemaprefix_yn='N' then
        dbms_metadata.set_transform_param(dbms_metadata.session_transform,'EMIT_SCHEMA',false);
      end if;
    exception
      when others then
        null;
    end;

    if in_type_cd = 'TRIGGER'  then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
    else
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',false);
    end if;

    if in_type_cd='PACKAGE' then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SPECIFICATION',true);
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'BODY',false);
    end if;

    if in_type_cd='PACKAGE BODY' then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SPECIFICATION',false);
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'BODY',true);
    end if;

    if in_type_cd='TYPE' then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SPECIFICATION',true);
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'BODY',false);
    end if;

    if in_type_cd='TYPE BODY' then
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SPECIFICATION',false);
      dbms_metadata.set_transform_param(dbms_metadata.session_transform,'BODY',true);
    end if;


    v_originalDDL_cl := dbms_metadata.get_ddl(v_type_cd, in_name_tx,in_schema_cd);
    v_cl := v_originalDDL_cl;

    if in_type_cd = 'TRIGGER' then
      v_cl:=substr(v_cl,1,instr(v_cl,'/'||chr(10)||'ALTER TRIGGER'));
      v_insteadOf_yn:=isInsteadOfTrigger(v_cl);
    end if;
    -- trim for convenience
    v_cl := rtrim(rtrim(v_cl),chr(10));
    v_cl := ltrim(ltrim(v_cl,chr(10)));
    if in_schemaprefix_yn='Y' or in_schemaprefix_yn is null then
      if in_type_cd = 'TRIGGER' then
        v_cl := qualifyBaseObject(v_cl, in_schema_cd);
      elsif in_type_cd='SYNONYM' then
        v_cl := qualifyBaseObjectSynonym(v_cl, in_schema_cd);
      end if;
    end if;
    if v_insteadOf_yn='Y' and in_schemaprefix_yn='N' then
      v_cl := removeBaseObject(v_cl, in_schema_cd);
    end if;
  return v_cl;
exception
  when others then
    return v_cl;
end;

END;
/

CREATE OR REPLACE TRIGGER TBLACK.dept_trg1
              before insert ON TBLACK.DEPT
              for each row
begin
                  if :new.deptno is null then
                      select dept_seq.nextval into :new.deptno from sys.dual;
                 end if;
              end;
/

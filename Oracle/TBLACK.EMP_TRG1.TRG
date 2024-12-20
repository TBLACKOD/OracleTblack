CREATE OR REPLACE TRIGGER TBLACK.emp_trg1
              before insert ON TBLACK.EMP
              for each row
begin
                  if :new.empno is null then
                      select emp_seq.nextval into :new.empno from sys.dual;
                 end if;
              end;
/

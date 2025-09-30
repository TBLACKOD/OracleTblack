create or replace package test1 is

function testf return varchar2;

end test1;
/
create or replace package body test1 is


function testf return varchar2 as
  
begin
  return 'test44';
end;

end test1;
/

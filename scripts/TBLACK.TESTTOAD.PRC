CREATE OR REPLACE PROCEDURE TBLACK.TestToad IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       TestToad
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/01/2025   KOSTYA       1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TestToad
      Sysdate:         23/01/2025
      Date and Time:   23/01/2025, 01:42:06, and 23/01/2025 01:42:06
      Username:        KOSTYA (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   tmpVar := 1;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TestToad;
/

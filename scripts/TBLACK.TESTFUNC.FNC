CREATE OR REPLACE FUNCTION TBLACK.TESTFUNC RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       TESTFUNC
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/01/2025   db       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TESTFUNC
      Sysdate:         23/01/2025
      Date and Time:   23/01/2025, 13:24:26, and 23/01/2025 13:24:26
      Username:        db (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN
   tmpVar := 3;
   RETURN tmpVar;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END TESTFUNC;
/

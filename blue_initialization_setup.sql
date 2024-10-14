-- BLUE connect as user sys to FREEPDB1
-- delete the TBS_VECTOR datafile and VECTOR_USER before start if exists
/* 

DROP TABLESPACE TBS_VECTOR
   INCLUDING CONTENTS AND DATAFILES;
drop user "VECTOR_USER" CASCADE; 

*/

-- Step 1 - Create Tablespace
create bigfile tablespace TBS_VECTOR datafile '/opt/oracle/oradata/FREE/FREEPDB1/tbs_vector.dbf' size 256M autoextend on maxsize 2G;

-- Step 2 - Create User and Grant Accesses
create user vector_user identified by "Oracle_4U"
default tablespace TBS_VECTOR temporary tablespace TEMP
quota unlimited on TBS_VECTOR;
GRANT create mining model TO vector_user;

-- Step 3 - Grant the 23ai new DB_DEVELOPER_ROLE to the user
grant DB_DEVELOPER_ROLE to vector_user;


/*
Getting a data set downloaded here: 
https://frt4wbawy9o0.objectstorage.eu-frankfurt-1.oci.customer-oci.com/p/jhEbjXLm7R5FjqfOv37lmjoZBQa6bcINYAQMnomiSVwK9Oal5kfIspAObeBrlEQo/n/frt4wbawy9o0/b/work-share/o/VSDemo/dataset_200K.txt
*/

-- Step 4 - Create an external table on top of this file

CREATE OR REPLACE DIRECTORY dm_dump as '/home/oracle';
GRANT READ, WRITE ON DIRECTORY dm_dump TO vector_user;



-- Step 15 After running vector search demo go to configuring API and access connect as sys to pdb FREEPDB1
-- configure ORDS: connect as sys to pdb FREEPDB1 AFTER embbeding

grant SODA_APP to VECTOR_USER; -- Simple Oracle Document Access (SODA) 

BEGIN
    ords_admin.enable_schema (
        p_enabled               => TRUE,
        p_schema                => 'VECTOR_USER',
        p_url_mapping_type      => 'BASE_PATH',
        p_url_mapping_pattern   => 'aivectors',
        p_auto_rest_auth        => TRUE  
    );
    COMMIT;
END;

/*try with:

http://localhost:8080/ords/freepdb1/aivectors/ai/ccnews/little%20red%20corvette 

*/
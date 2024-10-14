-- BLUE connect as user sys to FREEPDB1
-- delete the TBS_VECTOR01 datafile befor start
/*DROP TABLESPACE TBS_VECTOR01
   INCLUDING CONTENTS AND DATAFILES;
drop user "VECTOR_USER01" CASCADE;*/

create bigfile tablespace TBS_VECTOR01 datafile '/opt/oracle/oradata/FREE/FREEPDB1/tbs_vector01.dbf' size 256M autoextend on maxsize 2G;

-- delete vector_user01 for demo -- 


create user vector_user01 identified by "Oracle_4U"
default tablespace TBS_VECTOR01 temporary tablespace TEMP
quota unlimited on TBS_VECTOR01;
GRANT create mining model TO vector_user01;

-- Grant the 23ai new DB_DEVELOPER_ROLE to the user
grant DB_DEVELOPER_ROLE to vector_user01;


/*getting a data set downloaded here https://objectstorage.eu-frankfurt-1.oraclecloud.com/n/fro8fl9kuqli/b/AIVECTORS/o/dataset_200K.txt.
The next step will be creating an external table on top of this file*/

-- connect as user sys to FREEPDB1

CREATE OR REPLACE DIRECTORY dm_dump as '/home/oracle';
GRANT READ, WRITE ON DIRECTORY dm_dump TO vector_user01;


-- After running green vector search demo go to configuring API and access connect as sys to pdb FREEPDB1
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
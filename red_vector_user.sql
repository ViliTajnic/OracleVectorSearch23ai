-- sqlplus vector_user/Oracle_4U@FREEPDB1
-- Step 5 - Create a table from data set downloaded to dm_dump

CREATE TABLE if not exists CCNEWS_TMP (sentence VARCHAR2(4000))
  ORGANIZATION EXTERNAL (TYPE ORACLE_LOADER DEFAULT DIRECTORY dm_dump
                         ACCESS PARAMETERS
                           (RECORDS DELIMITED BY 0x'0A'
                            READSIZE 100000000
                            FIELDS (sentence CHAR(4000)))
                         LOCATION (dm_dump:'dataset_200K.txt'))
  PARALLEL
  REJECT LIMIT UNLIMITED;

-- Step 6 - Check that the external table is correct
select count(*) from CCNEWS_TMP;

-- Step 7 -  Check the three first rows

select * from CCNEWS_TMP where rownum < 4;

/* 
Step 8 - Calculate vector embeddings for the data set. Use all-MiniLM-L6-v2 sentence transformer model from here:
https://frt4wbawy9o0.objectstorage.eu-frankfurt-1.oci.customer-oci.com/p/_lYIoIPT8PPdbQkRoQQFPBSvOynVDkuWHV6P7LfYTrAr5DAvThViUfh1Jfx6pRYb/n/frt4wbawy9o0/b/work-share/o/VSDemo/all-MiniLM-L6-v2.onnx
Copy the all-MiniLM-L6-v2.onnx file to the path corresponding to the DM_DUMP director
*/

EXECUTE DBMS_VECTOR.LOAD_ONNX_MODEL('DM_DUMP','all-MiniLM-L6-v2.onnx','doc_model')

-- Step 9 - Check that the model was correctly loaded by querying the following dictionary views

/* formating for running in sqlplus

col model_name format a12
col mining_function format a12
col algorithm format a12
col attribute_name format a20
col data_type format a20
col vector_info format a30
col attribute_type format a20
set lines 120       

*/

SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'DOC_MODEL'
ORDER BY model_name;

-- Step 10 - Describe the model more on details

SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'DOC_MODEL'
ORDER BY attribute_name;

-- Step 11 - Create a target table with a column vec with data type VECTOR

create table if not exists CCNEWS (
    id number(10) not null,
    info VARCHAR2(4000),
    vec VECTOR
);

-- Step 12 - Use the doc_model previously loaded to calculate the vector embeddings. Depending on environment it will take cca. 40 minutes to complete this step.

insert into CCNEWS (id, info, vec)
select rownum,
       sentence,
       TO_VECTOR(VECTOR_EMBEDDING(doc_model USING sentence as data))
from CCNEWS_TMP;
COMMIT;

-- More on vector distance here: https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/vector_distance.html

/* formating for running in sqlplus:
set timing on
col info format a90
set lines 120
*/

-- Step 13 - Run a vector search against the input string

select id, info
from CCNEWS
order by vector_distance(vec, TO_VECTOR(VECTOR_EMBEDDING(doc_model USING 'japanese car industry' as data)), COSINE)
fetch approx first 5 rows only;

-- Step 14 - Optionaly check the execution plan in sqlplus with user sqlplus vector_user/Oracle_4U@FREEPDB1

set autotrace traceonly explain

select id, info
from CCNEWS
order by vector_distance(vec, TO_VECTOR(VECTOR_EMBEDDING(doc_model USING 'little red corvette' as data)), COSINE)
fetch approx first 5 rows only;
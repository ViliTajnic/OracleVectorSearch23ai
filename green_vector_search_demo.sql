/* GREEN sqlplus vector_user/Oracle_4U@FREEPDB1
More on vector distance here: https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/vector_distance.html*/

set timing on
col info format a90
set lines 120

select id, info
from CCNEWS
order by vector_distance(vec, TO_VECTOR(VECTOR_EMBEDDING(doc_model USING 'japanese car industry' as data)), COSINE)
fetch approx first 5 rows only;

-- Optionaly check the execution plan in sqlplus with user sqlplus vector_user/Oracle_4U@FREEPDB1

set autotrace traceonly explain

select id, info
from CCNEWS
order by vector_distance(vec, TO_VECTOR(VECTOR_EMBEDDING(doc_model USING 'little red corvette' as data)), COSINE)
fetch approx first 5 rows only;



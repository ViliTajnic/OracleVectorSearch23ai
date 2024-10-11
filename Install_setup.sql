-- connect as user sys to FREEPDB1

create bigfile tablespace TBS_VECTOR datafile size 256M autoextend on maxsize 2G;

create user vector_user identified by "Oracle_4U"
default tablespace TBS_VECTOR temporary tablespace TEMP
quota unlimited on TBS_VECTOR;
GRANT create mining model TO vector_user;

-- Grant the 23ai new DB_DEVELOPER_ROLE to the user
grant DB_DEVELOPER_ROLE to vector_user;

-- setup access



CREATE OR REPLACE VIEW view_objects AS
WITH
object AS (
SELECT classid, objid, objsubid FROM pg_depend
UNION
SELECT refclassid, refobjid, refobjsubid FROM pg_depend
),
object_info AS (
SELECT
object.classid::oid             AS classid,
object.objid::oid               AS objid,
object.objsubid::integer        AS objsubid,
NULL::name                      AS access_method_name,
NULL::int2                      AS operator_strategy_number,
NULL::int2                      AS support_function_number,
NULL::text                      AS support_function_name,
NULL::name                      AS attribute_name,
NULL::name                      AS role_name,
NULL::name                      AS relation_name,
NULL::text                      AS relation_kind,
NULL::name                      AS constraint_name,
NULL::name                      AS conversion_name,
NULL::name                      AS database_name,
NULL::name                      AS enumerator_name,
pg_foreign_data_wrapper.fdwname AS foreign_data_wrapper_name,
NULL::name                      AS foreign_server_name,
NULL::name                      AS language_name,
NULL::name                      AS namespace_name,
NULL::name                      AS operator_class_name,
NULL::name                      AS operator_name,
NULL::name                      AS operator_family_name,
NULL::text                      AS function_name,
NULL::oidvector                 AS function_input_argument_types,
NULL::name                      AS rule_name,
NULL::name                      AS tablespace_name,
NULL::name                      AS trigger_name,
NULL::text                      AS data_type_name,
NULL::text                      AS source_data_type_name,
NULL::text                      AS target_data_type_name,
NULL::text                      AS left_data_type_name,
NULL::text                      AS right_data_type_name,
NULL::name                      AS text_search_configuration_name,
NULL::name                      AS text_search_dictionary_name,
NULL::name                      AS text_search_parser_name,
NULL::name                      AS text_search_template_name
FROM object
JOIN pg_foreign_data_wrapper ON (object.classid = 'pg_foreign_data_wrapper'::regclass AND pg_foreign_data_wrapper.oid = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_authid.rolname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_authid               ON (object.classid = 'pg_authid'::regclass               AND pg_authid.oid               = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_foreign_server.srvname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_foreign_server       ON (object.classid = 'pg_foreign_server'::regclass       AND pg_foreign_server.oid       = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
pg_am.amname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_am                   ON (object.classid = 'pg_am'::regclass                   AND pg_am.oid                   = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_namespace            ON (object.classid = 'pg_namespace'::regclass            AND pg_namespace.oid            = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_tablespace.spcname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_tablespace           ON (object.classid = 'pg_tablespace'::regclass           AND pg_tablespace.oid           = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_authid.rolname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_foreign_server.srvname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_user_mapping         ON (object.classid = 'pg_user_mapping'::regclass AND pg_user_mapping.oid   = object.objid)
JOIN pg_authid               ON (object.classid = 'pg_user_mapping'::regclass AND pg_authid.oid         = pg_user_mapping.umuser)
JOIN pg_foreign_server       ON (object.classid = 'pg_user_mapping'::regclass AND pg_foreign_server.oid = pg_user_mapping.umserver)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_class.relname,
NULL,
pg_constraint.conname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_constraint ON (object.classid = 'pg_constraint'::regclass AND pg_constraint.oid = object.objid)
JOIN pg_namespace  ON (object.classid = 'pg_constraint'::regclass AND pg_namespace.oid  = pg_constraint.connamespace)
LEFT JOIN pg_class ON (pg_constraint.conrelid = pg_class.oid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_conversion.conname,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_conversion ON (object.classid = 'pg_conversion'::regclass AND pg_conversion.oid = object.objid)
JOIN pg_namespace  ON (object.classid = 'pg_conversion'::regclass AND pg_namespace.oid  = pg_conversion.connamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
pg_am.amname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
pg_opclass.opcname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_opclass   ON (object.classid = 'pg_opclass'::regclass AND pg_opclass.oid   = object.objid)
JOIN pg_am        ON (object.classid = 'pg_opclass'::regclass AND pg_am.oid        = pg_opclass.opcmethod)
JOIN pg_namespace ON (object.classid = 'pg_opclass'::regclass AND pg_namespace.oid = pg_opclass.opcnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
pg_am.amname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
pg_opfamily.opfname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_opfamily  ON (object.classid = 'pg_opfamily'::regclass AND pg_opfamily.oid  = object.objid)
JOIN pg_am        ON (object.classid = 'pg_opfamily'::regclass AND pg_am.oid        = pg_opfamily.opfmethod)
JOIN pg_namespace ON (object.classid = 'pg_opfamily'::regclass AND pg_namespace.oid = pg_opfamily.opfnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
_format_type(pg_catalog.pg_type.oid,NULL),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_type      ON (object.classid = 'pg_type'::regclass AND pg_type.oid      = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_type'::regclass AND pg_namespace.oid = pg_type.typnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_enum.enumlabel,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
_format_type(pg_catalog.pg_type.oid,NULL),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_enum      ON (object.classid = 'pg_enum'::regclass AND pg_enum.oid      = object.objid)
JOIN pg_type      ON (object.classid = 'pg_enum'::regclass AND pg_type.oid      = pg_enum.enumtypid)
JOIN pg_namespace ON (object.classid = 'pg_enum'::regclass AND pg_namespace.oid = pg_type.typnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
_format_type(pg_cast.castsource,NULL),
_format_type(pg_cast.casttarget,NULL),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_cast ON (object.classid = 'pg_cast'::regclass AND pg_cast.oid = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
pg_operator.oprname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
_format_type(pg_operator.oprleft,NULL),
_format_type(pg_operator.oprright,NULL),
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_operator  ON (object.classid = 'pg_operator'::regclass AND pg_operator.oid  = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_operator'::regclass AND pg_namespace.oid = pg_operator.oprnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_language.lanname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_language ON (object.classid = 'pg_language'::regclass AND pg_language.oid = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
quote_ident(pg_proc.proname),
pg_proc.proargtypes,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_proc      ON (object.classid = 'pg_proc'::regclass AND pg_proc.oid      = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_proc'::regclass AND pg_namespace.oid = pg_proc.pronamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_ts_config.cfgname,
NULL,
NULL,
NULL
FROM object
JOIN pg_ts_config ON (object.classid = 'pg_ts_config'::regclass AND pg_ts_config.oid = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_ts_config'::regclass AND pg_namespace.oid = pg_ts_config.cfgnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_ts_dict.dictname,
NULL,
NULL
FROM object
JOIN pg_ts_dict   ON (object.classid = 'pg_ts_dict'::regclass AND pg_ts_dict.oid   = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_ts_dict'::regclass AND pg_namespace.oid = pg_ts_dict.dictnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_ts_parser.prsname,
NULL
FROM object
JOIN pg_ts_parser ON (object.classid = 'pg_ts_parser'::regclass AND pg_ts_parser.oid = object.objid)
JOIN pg_namespace ON (object.classid = 'pg_ts_parser'::regclass AND pg_namespace.oid = pg_ts_parser.prsnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_ts_template.tmplname
FROM object
JOIN pg_ts_template ON (object.classid = 'pg_ts_template'::regclass AND pg_ts_template.oid = object.objid)
JOIN pg_namespace   ON (object.classid = 'pg_ts_template'::regclass AND pg_namespace.oid   = pg_ts_template.tmplnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
pg_am.amname,
pg_amop.amopstrategy,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
pg_operator.oprname,
pg_opfamily.opfname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
_format_type(pg_operator.oprleft,NULL),
_format_type(pg_operator.oprright,NULL),
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_amop                             ON (object.classid = 'pg_amop'::regclass AND pg_amop.oid      = object.objid)
JOIN pg_opfamily                         ON (object.classid = 'pg_amop'::regclass AND pg_opfamily.oid  = pg_amop.amopfamily)
JOIN pg_am                               ON (object.classid = 'pg_amop'::regclass AND pg_am.oid        = pg_opfamily.opfmethod)
JOIN pg_operator                         ON (object.classid = 'pg_amop'::regclass AND pg_operator.oid  = pg_amop.amopopr)
JOIN pg_namespace                        ON (object.classid = 'pg_amop'::regclass AND pg_namespace.oid = pg_operator.oprnamespace AND pg_namespace.oid = pg_opfamily.opfnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
pg_am.amname,
NULL,
pg_amproc.amprocnum,
pg_amproc.amproc::regprocedure::text,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
pg_opfamily.opfname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_amproc               ON (object.classid = 'pg_amproc'::regclass AND pg_amproc.oid               = object.objid)
JOIN pg_opfamily             ON (object.classid = 'pg_amproc'::regclass AND pg_opfamily.oid             = pg_amproc.amprocfamily)
JOIN pg_am                   ON (object.classid = 'pg_amproc'::regclass AND pg_am.oid                   = pg_opfamily.opfmethod)
JOIN pg_namespace            ON (object.classid = 'pg_amproc'::regclass AND pg_namespace.oid            = pg_opfamily.opfnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_database.datname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_database ON (object.classid = 'pg_database'::regclass AND pg_database.oid = object.objid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
pg_attribute.attname,
NULL,
pg_class.relname,
CASE pg_class.relkind WHEN 'c' THEN 'composite type' WHEN 'i' THEN 'index' WHEN 'r' THEN 'table' WHEN 't' THEN 'toast table' WHEN 'v' THEN 'view' WHEN 'S' THEN 'sequence' END::text,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_class          ON (object.classid = 'pg_class'::regclass AND pg_class.oid          = object.objid)
JOIN pg_namespace      ON (object.classid = 'pg_class'::regclass AND pg_namespace.oid      = pg_class.relnamespace)
LEFT JOIN pg_attribute ON (object.classid = 'pg_class'::regclass AND pg_attribute.attrelid = pg_class.oid AND pg_attribute.attnum::integer = object.objsubid)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
pg_attribute.attname,
NULL,
pg_class.relname,
CASE pg_class.relkind WHEN 'c' THEN 'composite type' WHEN 'i' THEN 'index' WHEN 'r' THEN 'table' WHEN 't' THEN 'toast table' WHEN 'v' THEN 'view' WHEN 'S' THEN 'sequence' END::text,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_attrdef   ON (object.classid = 'pg_attrdef'::regclass AND pg_attrdef.oid      = object.objid)
JOIN pg_class     ON (object.classid = 'pg_attrdef'::regclass AND pg_class.oid        = pg_attrdef.adrelid)
JOIN pg_namespace ON (object.classid = 'pg_attrdef'::regclass AND pg_namespace.oid      = pg_class.relnamespace)
JOIN pg_attribute ON (object.classid = 'pg_attrdef'::regclass AND pg_attribute.attrelid = pg_class.oid AND pg_attribute.attnum::integer = pg_attrdef.adnum)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_class.relname,
CASE pg_class.relkind WHEN 'c' THEN 'composite type' WHEN 'i' THEN 'index' WHEN 'r' THEN 'table' WHEN 't' THEN 'toast table' WHEN 'v' THEN 'view' END::text,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_rewrite.rulename,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_rewrite   ON (object.classid = 'pg_rewrite'::regclass AND pg_rewrite.oid   = object.objid)
JOIN pg_class     ON (object.classid = 'pg_rewrite'::regclass AND pg_class.oid     = pg_rewrite.ev_class)
JOIN pg_namespace ON (object.classid = 'pg_rewrite'::regclass AND pg_namespace.oid = pg_class.relnamespace)
UNION ALL
SELECT
object.classid,
object.objid,
object.objsubid,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_class.relname,
CASE pg_class.relkind WHEN 'c' THEN 'composite type' WHEN 'i' THEN 'index' WHEN 'r' THEN 'table' WHEN 't' THEN 'toast table' WHEN 'v' THEN 'view' END::text,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_namespace.nspname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
pg_trigger.tgname,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
FROM object
JOIN pg_trigger   ON (object.classid = 'pg_trigger'::regclass AND pg_trigger.oid   = object.objid)
JOIN pg_class     ON (object.classid = 'pg_trigger'::regclass AND pg_class.oid     = pg_trigger.tgrelid)
JOIN pg_namespace ON (object.classid = 'pg_trigger'::regclass AND pg_namespace.oid = pg_class.relnamespace)
)
SELECT * FROM view_objects;



function_num_arguments AS (
    SELECT array_upper(cols.function_input_argument_types,1)+1 AS function_num_arguments FROM cols
),
function_argument_position AS (
    SELECT function_argument_position
    FROM pg_catalog.generate_series(1,(SELECT function_num_arguments FROM function_num_arguments)) AS function_argument_position
),
function_args_in_order AS (
    SELECT function_argument_position, _format_type(cols.function_input_argument_types[function_argument_position-1],NULL) AS typname
    FROM function_argument_position, cols
    ORDER BY function_argument_position
),
function_info AS (
    SELECT array_to_string(array_agg(function_args_in_order.typname),',') AS function_arguments FROM function_args_in_order
),
formatted_text AS (
SELECT
    CASE
        WHEN object.classid = 'pg_ts_template'::regclass THEN 'text search template ' || cols.text_search_template_name
        WHEN object.classid = 'pg_ts_parser'::regclass   THEN 'text search parser ' || cols.text_search_parser_name
        WHEN object.classid = 'pg_ts_config'::regclass   THEN 'text search configuration ' || cols.text_search_configuration_name
        WHEN object.classid = 'pg_ts_dict'::regclass     THEN 'text search dictionary ' || cols.text_search_dictionary_name
        WHEN object.classid = 'pg_database'::regclass    THEN 'database ' || cols.database_name
        WHEN object.classid = 'pg_namespace'::regclass   THEN 'schema ' || cols.namespace_name
        WHEN object.classid = 'pg_language'::regclass    THEN 'language ' || cols.language_name
        WHEN object.classid = 'pg_conversion'::regclass  THEN 'conversion ' || cols.conversion_name
        WHEN object.classid = 'pg_constraint'::regclass  THEN 'constraint ' || cols.namespace_name || '.' || cols.constraint_name || COALESCE(' on table ' || cols.relation_name,'')
        WHEN object.classid = 'pg_rewrite'::regclass     THEN 'rule ' || cols.rule_name || ' on ' || cols.relation_kind || ' ' || cols.namespace_name || '.' || cols.relation_name
        WHEN object.classid = 'pg_trigger'::regclass     THEN 'trigger ' || cols.trigger_name || ' on ' || cols.relation_kind || ' ' || cols.namespace_name || '.' || cols.relation_name
        WHEN object.classid = 'pg_cast'::regclass        THEN 'cast from ' || cols.source_data_type_name || ' to ' || cols.target_data_type_name
        WHEN object.classid = 'pg_amproc'::regclass      THEN 'function ' || cols.support_function_number || ' ' || cols.support_function_name || ' of operator family ' || cols.operator_family_name || ' for access method ' || cols.access_method_name
        WHEN object.classid = 'pg_operator'::regclass    THEN 'operator ' || cols.namespace_name || '.' || cols.operator_name || '(' || cols.left_data_type_name || ',' || cols.right_data_type_name || ')'
        WHEN object.classid = 'pg_amop'::regclass        THEN 'operator ' || cols.operator_strategy_number || ' ' || cols.namespace_name || '.' || cols.operator_name || '(' || cols.left_data_type_name || ',' || cols.right_data_type_name || ')' || ' of operator family ' || cols.operator_family_name || ' for access method ' || cols.access_method_name
        WHEN object.classid = 'pg_opfamily'::regclass    THEN 'operator family ' || cols.operator_family_name || ' for access method ' || cols.access_method_name
        WHEN object.classid = 'pg_opclass'::regclass     THEN 'operator class ' || cols.operator_class_name || ' for access method ' || cols.access_method_name
        WHEN object.classid = 'pg_class'::regclass       THEN cols.relation_kind || ' ' || cols.namespace_name || '.' || cols.relation_name
        WHEN object.classid = 'pg_type'::regclass        THEN 'type ' || cols.data_type_name
        WHEN object.classid = 'pg_proc'::regclass        THEN 'function ' || cols.namespace_name || '.' || cols.function_name || '(' || COALESCE(function_info.function_arguments,'') || ')'
        WHEN object.classid = 'pg_attrdef'::regclass     THEN 'default for ' || cols.relation_kind || ' ' || cols.relation_name || ' column ' || cols.attribute_name
    END || CASE WHEN object.classid = 'pg_class'::regclass AND object.objsubid <> 0 THEN ' column ' || cols.attribute_name ELSE '' END
    AS identifier
FROM object, cols, function_info
)
SELECT * FROM 
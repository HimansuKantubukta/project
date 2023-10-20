  /////////////////////////////////////////////////////////////////////////////////////
  // A generic SQL PEG grammar for SQL dialect translation. Copyright Prolifics 2023 //
  /////////////////////////////////////////////////////////////////////////////////////

  {{
    function node(nodeName, ruleName, convertedTree, originalTree )
    { return o.convert && ruleName ? convertedTree : originalTree }

    // Formatting controls
    let level=0
    let indentSpaces=2
    function down(){level+=+1;return true}
    function up()  {level+=-1;return true}
    function indent(){return ' '.repeat(indentSpaces * level)}

    // Options
    let o={ 
    // Debug
      debug     : 0  // set 1 to enable debug
    , log_text  : 0  // output parsed text to the console
    , ast       : 0  // set to output AST rather than converted code
    , catch_all : 0  // set to true to let the parser continue if it fails to reconise some code
    , test      : 0  // set to 1 to set al options to true
  // Output
    , convert  : false   // set to pick converted rather than the original code from the parse tree
    , refactor : false   // set when you don't want to covert dialects but you do want to make your SQL more standard - get closer to "just the good bit" of SQL.   
    , format   : false   // set to format whitespace
    , analyze  : false   // return the specifically captured elements rather than converted code
    // Source SQL dialect
    , fromDb2      : false
    , fromOracle   : false
    , fromPostgres : false
    , fromSnowflake: false
    , fromMSSQL    : false
    // Target SQL dialect
    , toDb2       : false
    , toOracle    : false
    , toPostgres  : false
    , toEDB       : false
    , toSnowflake : false
    , toMSSQL     : false
    // Source non-SQL templating/emedding dialects
    , fromJava : false
  // Parsing Options
    , sqDelimitedSqlIdentifier          : false // Reconise single quoted identifiers which SQL server allows (albeit highly disouraged my MS)
    , dqDelimitedString                 : false // Reconise double quoted string literals as allowed in SQL Server with thier QUOTED_IDENTIFIER set to OFF
    , sbDelimitedSqlIdentifier          : false // Reconise square bracket quoted identifiers
    , non_sql                           : false // Reconise and skip some types on embeded non-SQL syntax such as {{ }}
  // Convertion Switches
    , add_from_dummy_table              :  false // adds a dummy FROM table for SELECTs without a FROM clause
    , add_or_replace                    :  false // add OR REPLACE to DDL such as CREATE PROCEDURE
    , add_if_exists                     :  false // add IF EXISTS to DDL such as DROP PROCEDURE 
    , add_if_not_exists                 :  false // add IF NOT EXISTS to DDL such as CREATE PROCEDURE
    , add_stmtDelimiter                 :  false // Add missing any missing statement delimiters
    , add_underscore_to_currents        :  false // add underscore to e.g. CURRENT DATE
    , concat_to_double_pipe             :  false // convert CONCAT function to sequence of || infix operators. Usefull for MS SQL -> Oracle
    , double_pipe_to_plus               :  false // convert || infix operator to +. Usefull for Oracle -> MS SQL
    , convert_to_cast                   :  false // convert MS SQL CONVERT() function to a CAST
    , datetime_functions_to_arithmetic  :  false // convert DATEADD(), TIMEADD(), ADD_DAYS() etc to SQL date arithmetic
    , datetime_functions_to_extract     :  false // convert YEAR(x), MONTH(x) etc to EXTRACT(year/month... from x)
    , decode_to_case                    :  false // convert DECODE to CASE statements (TO-DO cater for NULL in the DECODE list)
    , extract_to_datetime_function      :  false // convert EXTRACT(year/month... from x) convert YEAR(x), MONTH(x) etc
    , eat_AS_on_tableAlias              :  false // Oracle does not support using AS when aliasing in a FROM clause
    , eatTSQLSet                        :  false // remove Transact-SQL session SET statements such as SET ANSI_DEFAULTS
    , eatUse                            :  false // remove all USE statements
    , eatDefaultNamedParam              :  false // remove any named parameters that use the DEFAULT keyword
    , eatIndexes                        :  false // remove any CREATE INDEX statements
    , eatIndexOptions                   :  false // remove any physical options on create indexes
    , greedy_plus_to_double_pipe        :  false // convert + to || if there is at least one string expression in a sequence of + operations
    , injectNullOrder                   :  false // add a NULLS FIRST/LAST to all ORDER BY expressions if not already there
    , iif_to_case                       :  false // convert the IIF function to a CASE statement
    , left_right_to_substr              :  false // convert LEFT/RIGHT to SUBSTR (using -ve offest for RIGHT)
    , name_ss                           :  false // add alias name to select stars   WORK IN PROGRESS... need to return and use (or name it SS) the first named alias from the alias list...
    , plus_to_double_pipe               :  false // convert + to || if used against string literals, string functions, or columns we infer are strings
    , quote_common_reserved_identifiers :  false // Double quote identifers that are "often" used as columns names such as e.g. DATE and that are reserved word in Oracle
    , quote_reserved_identifiers        :  false // Double quote identifers that are reserved words in the target DBMS
    , replace_stmtDelimiter             :  false // Replace statement delimiters
    , standardizeTypeNames              :  false // Conver some type aliases to more standard names, such as INT16 to SMALLINT
    , stuff_to_substr                   :  false // convert STUFF() to SUBSTR and concat
    , stuff_xml_to_listagg              :  false // Convert SQL Server hack to STRING_AGG/LISTAGG
    , to_char_to_cast                   :  false // Convert TO_CHAR(x) to a CAST
    , to_char_to_format                 :  false // Convert TO_CHAR(x, format) to FORMAT
    , top_to_limit                      :  false // Move and TOP n clause down to the LIMIT / FETCH FIRST x ROWS section
    , toType_func_to_cast               :  false // Convert e.g. TO_DATE(x) to CAST(x as DATE) for all functions prefixed TO_ and a simple type name
    , type_func_to_cast                 :  false // Convert e.g. VARCHAR(x,20) to CAST(x as VARCHAR(20)) for all functions that are simple type names
    , updateFrom_to_rowid_merge         :  false // Convert an UPDATE FROM xxx to a MERGE using ROWID as supported by e.g. Oracle
    , with_merge_to_merge               :  false // move WITH CTE into USING clause for DBMSes that don't support WITH before a MERGE 
    , xmlAggToStringAgg                 :  false // convert XMLAGG(XMLELEMENT to STRING_AGG
    // Conversion Literals
    , dummyTableName            : 'DUAL'       // name of dummy table to use with add_from_dummy_table
    , host_identifer_prefix     : ''           // Used if standardizing host identifers
    , limit_expression          : 'LIMIT'      // Used to standardize SQL in top_to_limit
    , limit_expression_postfix  : ' ROWS ONLY' // Used to standardize SQL in top_to_limit
    , nullOrder                 : 'NULLS LAST' // Used when injecting a NULLS clause on ordering
    , stringAggFunction         : 'STRING_AGG' // Set to e.g. LIST_AGG for other dialects
    , stmtDelimiter             : ';'          // Used if standardizing statement delimiters
    , targetLang                : 'plpgsql'    // Procedural language dialect to use in CREATE PROCEDURE
    // Conversion Defaults
    , defaultCastStringLength : 30            // used (e.g. by SQL Server) when no length given in CAST and CONVERT functions
    , defaultNumericPrecision : 18            // used when neither precision or scale given on a DECIMAL/NUMERIC type
    , defaultNumericScale : 0                 // used when neither precision or scale given on a DECIMAL/NUMERIC type
    // Conversion Functions
    , mapFunctionName : mapFunctionName_mssql_ora   // set to the specific function name mapping function
    , mapFunction     : mapFunction_mssql_ora
    , convertDateTimeStyle : convertDateTimeStyle_mssql_ora
    }

    let db =  // we assume you are targeting the latest version of a given DBMS. We don't try to cater for when features were added for example
    // items that are true indicate that the dialect support that syntax
    // The idea will be that when converting between dialects we can check if, e.g., the null sort is the same, and only inject null ordering if is not and is supported in the target
    // https://modern-sql.com/concept/null#compatibility
    [{db:'BigQuery', nullsFirstLast:false,nullSort:'first',isDistintFrom:true }
    ,{db:'Db2'     , nullsFirstLast:true ,nullSort:'last' ,isDistintFrom:true }
    ,{db:'MariaDB' , nullsFirstLast:false,nullSort:'first',isDistintFrom:false}
    ,{db:'MySQL'   , nullsFirstLast:false,nullSort:'first',isDistintFrom:false}
    ,{db:'Oracle'  , nullsFirstLast:true ,nullSort:'last' ,isDistintFrom:false}
    ,{db:'MSSQL'   , nullsFirstLast:false,nullSort:'first',isDistintFrom:true }
    ,{db:'SQLite'  , nullsFirstLast:false,nullSort:'first',isDistintFrom:true }
    ]

    // db.has = {
    //   isDistintFrom=['BigQuery','Db2','MSSQL','SQLite']
    // }

    function replaceParamMarkers(a){let c=1;let n=a;do{a=n;n=a.replace(/\?/,"$"+c);c=++c } while (n !== a); return n}

    function standardizeIdentifier(i,t){
      // Use this function to standardize all delimited identifers. By default we simply change all quoted identifers to be double quoted
      if ( t === 'hi' && o.host_identifer_prefix !== '' ) return o.host_identifer_prefix.concat(i.slice(1)); // for non-delmited identifiers, we coud e.g. upper case them here.. 
      if ( t === 'si' ) return i; // for non-delmited identifiers, we coud e.g. upper case them here.. 
      if (  t === 'dq' ) return '"'.concat(i.flat().join(''),'"'); 
      return '' + (Array.isArray(i) ? i.flat().join('') : i) + ''
    }
    function standardizeString(i,t){ // Use this function to standardize all string literals. We could incude escaping, or unescaping sequences.
      return "'"+ (Array.isArray(i) ? i.flat().join('') : i) +"'"
    }
    function concatText(a){ // concat all source or converted text properties
      if ( a === null || a === undefined ) return ''
      if ( typeof(a) ===  "string") return a
      if ( Array.isArray(a) ) {
          let r=''
          for (const e of a) { r=r.concat(concatText(e)) }
          return r
      }
      if ( (o.convert || o.format) && a.s !== undefined ) return concatText(a.s) // old logic to pick converted text
      if (  a.t !== undefined ) return concatText(a.t)  // old logic to pick un-converted text
      return a
    }
    function mapFunctionName_default(a){return  a}
    function mapFunctionName_mssql_ora(a){
      const map={ 'CHAR':'CHR', 'SUBSTRING':'SUBSTR', 'FORMAT':'TO_CHAR', 'LEN':'LENGTH', 'DATALENGTH':'LENGTHB', 'CHARINDEX':'INSTR','ISNULL':'COALESCE'
      , 'STR':'TO_CHAR', 'NEWID':'SYS_GUID' }
      return map[a.toUpperCase()] ? map[a.toUpperCase()] : a  // was ??
    }
      function mapFunctionName_ora_edb(a){
      const map={ 'NVL':'COALESCE'}
      return map[a.toUpperCase()] ? map[a.toUpperCase()] : a // was ??
    }
    function mapFunction_default(a){return undefined}
    function mapFunctionName_ora_mssql(a){
      const map={ 'CHR':'CHAR', 'SUBSTR':'SUBSTRING', 'LENGTH':'LEN', 'LENGTHB':'DATALENGTH', 'INSTR':'CHARINDEX', 'NVL':'COALESCE', 'LISTAGG':'STRING_AGG'
      , 'SYS_GUID': 'NEWID' }
      return map[a.toUpperCase()] ? map[a.toUpperCase()] : a  // was ??
    }
    function mapFunction_mssql_ora(a, ...b){
      // maps functions that have zero or more parameters
      switch ( a.toUpperCase() ){
        case 'GETDATE' : return 'CURRENT_TIMESTAMP'  // no parameters
        case 'MONTH'   : return 'EXTRACT(month from,'.concat(b.join(','),')' )
      }
      return [a,...b]
    }
      function mapFunction_ora_mssql(a, ...b){
      return [a,...b]
    }
    function convertDateTimeStyle_mssql_ora(a){
      const style={ // SQL Server to Oracle format conversion - not 100% tested. 
      // https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15
      // https://docs.oracle.com/cd/B19306_01/server.102/b14200/sql_elements004.htm#i34510
      // https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
        0:'Mon dd yyyy hh:miAM' ,1:'MM/dd/yy' ,2:'yy.MM.dd' ,3:'dd/MM/yy' ,4:'dd.MM.yy' ,5:'dd-MM-yy' ,6:'dd-Mon-yy' ,7:'Mon dd, yy' ,8:'HH24:mi:ss'
        ,9:'Mon dd yyyy hh:mi:ss:FF3AM' ,10:'MM-dd-yy' ,11:'yy/MM/dd' ,12:'yyMMdd' ,13:'dd Mon yyyy hh:mi:ss:FF3AM' ,14:'HH24:mi:ss:FF3'
        ,20:'yyyy-MM-dd HH24:mi:ss' ,21:'yyyy-MM-dd HH24:mi:ss:FF3' ,22:'MM/dd/yy hh:mi:ssAM' ,23:'yyyy-MM-dd' ,24:'HH24:mi:ss' ,25:'yyyy-MM-dd hh:mi:ss:FF3'
        ,100:'Mon dd yyyy hh:miAM' ,101:'MM/dd/yyyy' ,102:'yyyy.MM.dd' ,103:'dd/MM/yyyy' ,104:'dd.MM.yyyy' ,105:'dd-MM-yyyy' ,106:'dd Mon yyyy' ,107:'Mon dd, yyyy' ,108:'HH24:mi:ss'
        ,109:'Mon dd yyyy hh:mi:ss:FF3AM' ,110:'MM-dd-yyyy' ,111:'yyyy/MM/dd' ,112:'yyyyMMdd' ,113:'dd Mon yyyy HH24:mi:ss:FF3' ,114:'HH24:mi:ss:FF3'
        ,120:'yyyy-MM-dd HH24:mi:ss' ,121:'yyyy-MM-dd HH24:mi:ss:FF3' ,126:'yyyy-MM-dd T HH24:mi:ss:FF3' ,127:'yyyy-MM-dd T HH24:mi:ss:FF3' ,130:'dd MMm yyyy hh:mi:ss:FF3AM' ,131:'dd MMm yyyy hh:mi:ss:FF3AM'
    }
    return style[Number(a)]
    }
  }}

  // Per-parse initializer
  {
    // function used in all? return clauses in the grammar
    function node(nodeName, ruleName, convertedTree, originalTree )
    { if ( o.diff && o.convert && ruleName ) return {offset:offset(), s:originalTree } ;
      return o.convert && ruleName ? convertedTree : originalTree
    }


    // Variables pupulated by the parser
    var el={ funcs:[], params:[], expressions:[] } //  to hold SQL fragments found if o.analyse is true
    var cat={ tables:[], columns:[], tableOptions:[] } //  to hold catalog rows for any DDL found
    var scratch
    function resetSctatch(){ scratch={ table:"", columns:[], tableOptions:[] } } // to hold while reading DDL
    resetSctatch()
    var dbug={ skipped:[]}   // holds debugging info such as any text skipped by the grammar
    // variables switched during parsing
    var blockHasNotFoundHandler=false

  // override default options that are passed in at execution time
    for (let op in options){o[op] = options[op] } 

    //Set convertion options based on source/target - user can override by explictly passing convertion options setting 
    if (o.fromMSSQL) { 
      o.sqDelimitedSqlIdentifier = true
      o.sbDelimitedSqlIdentifier = true
      o.convert_to_cast = true
      o.plus_to_double_pipe = true
      // o.greedy_plus_to_double_pipe = true
      o.stuff_xml_to_listagg = true
      o.defaultCastStringLength = 30
      if (! o.toMSSQL) {
        o.add_stmtDelimiter = true
      }
    }
    if (o.toDb2 || o.toOracle) {
      o.add_from_dummy_table   = true
    }
    if (o.fromDb2){
      o.add_underscore_to_currents = true
      if (! o.toDb2) {
        o.replace_stmtDelimiter = true
      }
    }
    if (o.toDb2){
      o.dummyTableName = 'SYSIBM.SYSDYMMY1'
      o.stringAggFunction = 'LIST_AGG'
    }
    if (o.toEDB){
      o.toPostgres = true  // use both EDB and Postgres as targets for EDB
    }
    if (o.toPostgres){
      o.eatDefaultNamedParam = true
    }
    if (o.toMSSQL){
      o.stringAggFunction = 'STRING_AGG'
      o.host_identifer_prefix = '@'
      o.toType_func_to_cast = true
      o.decode_to_case = true
    }
    if (o.fromOracle && o.toMSSQL) {
      o.mapFunctionName = mapFunctionName_ora_mssql
      o.mapFunction     = mapFunction_ora_mssql
      o.to_char_to_cast = true
      o.to_char_to_format = true
      o.double_pipe_to_plus = true
      o.extract_to_datetime_function = true
    }

    if (o.toOracle) { 
      o.quote_reserved_identifiers = false
      o.quote_common_reserved_identifiers = true
      o.name_ss  = true
      o.eat_AS_on_tableAlias = true
      o.updateFrom_to_rowid_merge = true
      o.top_to_limit  = true
      o.limit_expression = 'FETCH FIRST' // From Oracle 12c (12.1)
      o.limit_expression_postfix = ' ROWS ONLY'
      o.defaultNumericPrecision = 18
      o.defaultNumericScale = 0 
      o.host_identifer_prefix = ':'
    }
    if (o.fromMSSQL && o.toOracle) {
      o.iif_to_case = true 
      o.concat_to_double_pipe = true
      o.datetime_functions_to_arithmetic = true
      o.datetime_functions_to_extract = true
      o.left_right_to_substr  = true
      o.stuff_to_substr = true
      o.mapFunctionName = mapFunctionName_mssql_ora   // set to the specific function name mapping function
      o.mapFunction     = mapFunction_mssql_ora
      o.convertDateTimeStyle = convertDateTimeStyle_mssql_ora
    }
      if (o.fromOracle && o.toEDB) {
      o.quote_reserved_identifiers = true
      o.xmlAggToStringAgg = true
      o.updateSelect_to_CTE = true
      o.mapFunctionName = mapFunctionName_ora_edb
    }

    //Set convertion options including those based on source/target
    if (o.refactor){ 
      o.convert_to_cast = true
      o.iif_to_case = true
      o.plus_to_double_pipe = true
      if (o.fromMSSQL) { 
        o.stuff_to_substr = true
        o.top_to_limit  = true
        o.limit_expression = 'OFFSET 0 ROWS FETCH FIRST'
        o.limit_expression_postfix = ' ROWS ONLY'
      }
    }

    // if test all rules is set, set all rule to true
    if(o.test) {
      for (let op in o){if(o[op]===false){ o[op] = true } }
      o.analyze = false
      o.format = false
      o.refactor = false

    }


    // override any defaults set above. E.g., use might want to go fromMSSQL but not convert_to_cast. They can pass both to achive that.
    for (let op in options){o[op] = options[op] } 
    if(o.debug){for (let op in o){if(o[op]){console.log(op,' = ',o[op])}}}
  }

  // TODO Need to revise the comment below (and coresponding code.)
  //  E.g. I belive that v and f are redundant, and that I add n sporadicaly and don't use it. Also I don't think I need to pass t about (text() is always avaible anyway)
  //    So likly all but s can be stripped out (maybe even just returning text, but I think that would limit future oportunities..)

  //  We return a structure that is arrays of object where 
  //      n is the node name
  //      f is formatted whitespace (if any)
  //      s is converted text (if any) and if a leaf node, or if a non-leaf node, converted object or array of objects/text
  //      t is original text if a leaf node, otherwise is an object or array of objects/text
  //      v is a value from that node (such as a function name)




  // 88""Yb  dP"Yb   dP"Yb  888888 
  // 88__dP dP   Yb dP   Yb   88   
  // 88"Yb  Yb   dP Yb   dP   88   
  // 88  Yb  YbodP   YbodP    88   

  root = r:stmts  {
      if (o.debug)    { console.log(dbug); console.log(r)}
      if (o.log_text) { /*console.log(cat) ;*/ console.log(concatText(r))}
      if (o.analyze) return el     // return the specifically captured elements 
      if (o.ast)     return r       // return the parse tree
      return concatText(r)     // Return the converted code (assuming the covert option above is set, oterhwise you will just get back the input as read) 
  }

  stmts = (  
      &{return o.fromJava} java
    / statement (a:(_ stmtDelimiter)? {return o.convert && o.add_stmtDelimiter && a === null ? o.stmtDelimiter : a} )
    / __
    /  &{return o.non_sql} nonSql
    // stmtDelimiter
    // TODO revise the best way to do a catch all
    // / &{return o.catch_all} e:expression            { dbug.skipped.push({n:'Expression', t:text()}); return {s:e} }
    // / &{return o.catch_all} [^ \t\n\r()'"\[\]\-,+]+ { dbug.skipped.push({n:'Not ws etc', t:text()}); return {s:text()} }
    // / &{return o.catch_all} catchAll                { dbug.skipped.push({n:'catch_all' , t:text()}); return {s:text()} }
    )*

  statement = compoundStmt / sqlStmt

  // Non compound SQL Statements (see PROC section for compond statements)
  sqlStmt = 
          valuesStmt  // come before full select as that can be a values expression (i.e. without an INTO)
        / fullSelect
        / createTable
        / alterTable
        / createView
        / createIndex
        / createProc
        / createType / dropType
        / createSequence
        / createVariable
        / createTrigger
        / createSchema
        / createModule 
        / alterModule
        / call
        / &{return o.fromMSSQL} exec
        / drop
        / connect
        / if
        / iterator
        / leaveIterate
        / case
        / declareHandler  // needs to be before declare
        / declare
        / signal
        / openClose
        / &{return o.with_merge_to_merge} withMerge
        / &{return o.updateFrom_to_rowid_merge} updateFrom
        / &{return o.updateSelect_to_CTE} updateSelect
        / (a:(fetch/update/delete/merge) {return blockHasNotFoundHandler && o.toPostgres ? a.concat(";\n    IF NOT FOUND THEN RAISE EXCEPTION 'NO_DATA_FOUND'; END IF") : a} )
        / prepareAndExecute
        / prepare
        / execute
        / getDiagnostics
        / insert
        / truncate
        / use
        / delimeter
        / &{return o.fromMSSQL || o.eatTSQLSet} msSQLSet
        / &{return o.fromMSSQL} msSQLSetVariable
        / setVariable
        / setParam
        / echo
        / beginTransaction/commit/rollback/throw
        / declareCursor 
        / declareVariable

  msSQLSet = "SET"i __  // to do group the paramets by what options they can take? https://learn.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql
    ( "DATEFIRST"i / "DATEFORMAT"i / "DEADLOCK_PRIORITY"i / "LOCK_TIMEOUT"i / "CONCAT_NULL_YIELDS_NULL"i / "CURSOR_CLOSE_ON_COMMIT"i / "FIPS_FLAGGER"i / "IDENTITY_INSERT"i / "LANGUAGE"i / "OFFSETS"i
    / "QUOTED_IDENTIFIER"i / "ARITHIGNORE"i / "FMTONLY"i / "NOCOUNT"i / "NOEXEC"i / "NUMERIC_ROUNDABORT"i / "PARSEONLY"i / "QUERY_GOVERNOR_COST_LIMIT"i / "RESULT"i __ "SET"i __ "CACHING"i / "ROWCOUNT"i / "TEXTSIZE"i 
    / "ANSI_DEFAULTS"i / "ANSI_NULL_DFLT"i / "ANSI_NULL_DFLT"i / "ANSI_NULLS"i / "ANSI_PADDING"i / "ANSI_WARNINGS"i / "FORCEPLAN"i / "SHOWPLAN_ALL"i / "SHOWPLAN_TEXT"i / "SHOWPLAN_XML"i 
    / "STATISTICS"i __ ("IO"i/"XML"i/"PROFILE"i/"TIME"i) / "IMPLICIT_TRANSACTIONS"i / "REMOTE_PROC_TRANSACTIONS"i / "TRANSACTION"i __ "ISOLATION"i __ "LEVEL"i / "XACT_ABORT"i
    ) (__ ("ON"i/"OFF"i/literal/isoLevel))? (_ stmtDelimiter)? { return o.eatTSQLSet ? "" : text() }

  isoLevel = 
        "READ"i __ "UNCOMMITTED"i
      / "READ"i __ "COMMITTED"i
      / "REPEATABLE"i __ "READ"
      / "SNAPSHOT"i
      / "SERIALIZABLE"i

  msSQLSetVariable = "SET"i __ "@" name _ "=" _ expression

  stmtDelimiter = (";" / "GO"i / "@" / "//") { return o.convert && o.replace_stmtDelimiter ? o.stmtDelimiter : text() }

  //ignore_until_next = stmtDelimiter / (! stmtDelimiter)+ stmtDelimiter { return '' }


  expression = r:(  &{return o.non_sql} nonSql / plusStringExpression / booleanExpression / baseExpression ) subPartorCast*
  baseExpression = complexExpression / literal / name 
  complexExpression = a:(cast / olap / function / subSelect  / subExpression / inList)  { if(o.analyze) el.expressions.push(concatText(a)); return a }

  booleanExpression = prefixOp expression (_ prefixOp expression)*
                  / baseExpression (infixOp expression)+
                  / baseExpression postfixOp (infixOp expression)?
                  / baseExpression  // a literal such as true, or a column name etc can be boolean
  infixOp = _ ( '+' / '-' / '*' / '/' / '%' / '^' / '=' / '!' _ '=' / '<<' / '>>' / '<' _ '>'  / '>' _ '=' / '<' _ '=' / '>' /  '<' / doublePipe / '&' / '|' / '^'  ) _
        / _ ( 'AND'i / 'OR'i / ("NOT"i __)? ( 'BETWEEN'i / 'IN'i / 'ILIKE'i / 'LIKE'i / 'SIMILAR'i )
                      / _ 'IS'i __ 'DISTINCT'i __ 'FROM'i / 'IS'i __ 'NOT'i __'DISTINCT' __ 'FROM'i /  _ 'AT'i __ 'TIME'i __ 'ZONE'i ) __
        / __ ( 'AND'i / 'OR'i / "NOT"i) __
  prefixOp     = ( '+' / '-' / '~' ) _
              / ( "EXISTS"i / "NOT"i __ "EXISTS"i / 'NOT'i ) _
  postfixOp =  __ ('IS'i (__ 'NOT'i)? __ ('NULL'i / boolean) / 'ISNULL'i / 'NOTNULL'i / 'ESCAPE'i __ string )
  subSelect = '(' down _ fullSelect _ up ')'
  subExpression = '(' _ expression _ ')'

  down = & {return down()}
  up = & {return up()}

  inList = '(' _ list _ ')'
  list = expression _ ',' _ list
      / expression

  delimeter = & {return o.MySQL} "DELIMITER"i  (_ stmtDelimiter)? { return o.convert && ! o.toMySQL ? "" : text() }

  use = a:("USE"i __ (("WAREHOUSE"i/"SCHEMA"i/"DATABASE"i/"ROLE"i) __)? name (_ stmtDelimiter)?)
    { return o.convert && o.eatUse
    ? "" 
    : a
    }

  setParam = "SET"i __ a:name (_ "=" _ / __) b:setValue
  setValue = ( literal / "ON"i / "OFF"i)

  delete = (with _)? "DELETE"i __ ("FROM"i __)? name (__ "WHERE"i __ booleanExpression)?
  insert = (with _)? "INSERT"i __ ("OVERWRITE"i __ )? into ("TABLE"i __)? name (_ nameList)? __ fullSelect
  truncate = "TRUNCATE" __ "TABLE" __ name

  merge =  (with _)? "MERGE"i into __ name __ (("AS"i __)? name __)? "USING"i __ expression __  (("AS"i __)? name __)?
      "ON"i __ functionExpressionList
      (__ when)+
  into = a:("INTO"i __)?
    { return o.convert && o.toSnowflake && !a 
    ? " INTO" 
    : a
    }

  withMerge =  a:("WITH"i __) b:(sqlIdentifier) c:(_ nameList)? d:(_ "AS"i _) e:(withBody _)
    f:("MERGE"i into __ name __ (("AS"i __)? name __)? "USING"i __) g:expression h:(__  (("AS"i __)? name __)?
      "ON"i __ functionExpressionList
      (__ when)+
    ) {return o.convert ? [].concat(f,e,h) : [].concat(a,b,c,d,e,f,g,h)}

  when = "WHEN"i __ ("NOT"i __)? "MATCHED" __ ( a:("BY"i __ ("TARGET"i/"SOURCE"i) __)? {return o.toSnowflake?"":a}) "THEN" __ mergeOperation
  mergeOperation = 
    "INSERT"i (_ nameList)? __ "VALUES"i __ '(' _ expressions _ ')'
  /  "DELETE"i
  /  "UPDATE"i  __ "SET"i __ name _ "=" _  (expression / subExpression ) (_ "," _ name _ "=" _  (expression / subExpression) )*

  update = 
    (with _)?
    "UPDATE"i __ name __ (("AS"i __)? !"SET"i name __)? 
    "SET"i __ name _ "=" _  (expression / subExpression ) (_ "," __ name __ "=" __  (expression / subExpression) )*
    (__ "WHERE"i __ "CURRENT"i __  "OF" __ name)?
    (__ from)?
    (_ where)? 

  // Convert an UPDATE from a sub-select to a MERGE
  updateFrom =
    a:"UPDATE"i
    b:(__ name) 
    c:(__) 
    d:("SET"i __ name _ "=" _)
    e:(expression / subExpression )
    f:(__ from)
    g:(__ where)? 
    { return o.convert
      ? ["MERGE INTO"].concat(b,"\nUSING( SELECT",b,".ROWID AS row_id, ",e," AS new_val ",f,g,") src\nON (ROWID = src.row_id)",c,"WHEN MATCHED THEN UPDATE ",d,"new_val" )
      : [].concat(a,b,c,d,e,f,g) 
    }

  // Convert an UPDATE from a sub-select to an UPDATE from a CTE
  updateSelect = 
    a:"UPDATE"i
    b:(_ '(' _ select _ ')' )
    c:(_) 
    d:("SET"i __ name __ "=" _)  
    e:( (expression / subExpression ) (_ "," __ name __ "=" __  (expression / subExpression) )* ) 
    g:(__ where)? 
    { return o.convert 
        ? ["WITH cte as "].concat(b,'\n',a,c,d,e,'\nFROM cte\n',g) 
        : [].concat(a,b,c,d,e,g)
    }

  call = "CALL"i  __  ( function / name)  // some dialects allow call with no parens

  exec = "EXEC"i __ 
    a:name
    b:(__ @msExecList)?
    { return o.convert && ! o.toMSSQL
      ? [].concat("CALL ",a,  (b ? [].concat(' (',...b,')') : "") )
      : text()
    } // todo deal with SQL Server EXECs without a following delimiter!

  msExecList = head:msExecItem tail:( _ ',' _ @msExecItem)* { return [head, ...tail]; }
  msExecItem = msVariable _ '=' _ b:literal {return b} / msVariable / literal
  msVariable = '@' name

  connect = "CONNECT"i __ ("RESET"i / ("TO" __ name)) _ stmtDelimiter  {return o.toPostgres ? "":text()}

  // db2 specials
  echo = ("echo" {return ! o.toDb2 ? "--echo":text()}) EOL

  createModule = "CREATE"i  __ orReplace "MODULE" __ name
  alterModule =  "ALTER"i  __ "MODULE" __ name __ ("PUBLISH"i /"ADD"i/"DROP"i) /// to be completed  https://www.ibm.com/docs/en/db2/11.5?topic=statements-alter-module

  orReplace      = a:("OR"i __ "REPLACE"i __)? { return !a && o.add_or_replace ? 'OR REPLACE ' : text() }
  orReplaceMatch = a:("OR"i __ "REPLACE"i __)? // Only add OR REPLACE on certain object

  ifNotExists = a:(__ "IF"i __ "NOT"i __ "EXISTS"i)? { return !a && o.add_if_not_exists ? ' IF NOT EXISTS' : text() }
  ifExists = a:(__ "IF"i __ "EXISTS"i)? { return !a && o.add_if_exists ? ' IF EXISTS' : text() }

  //  dP""b8 88""Yb 888888    db    888888 888888 
  // dP   `" 88__dP 88__     dPYb     88   88__   
  // Yb      88"Yb  88""    dP__Yb    88   88""   
  //  YboodP 88  Yb 888888 dP""""Yb   88   888888 

  drop = "DROP"i __ objectType ifExists __ name (_ '(' _ types _ ')')? (__ dropOption)?
  objectType = (tableType __?)* "TABLE"i
            / (viewType __?)* "VIEW"i
            / "FUNCTION"i / "SCHEMA"i / "SEQUENCE"i / "PROCEDURE"i / ("DISTINCT"i __)? "TYPE"i
  dropOption = "RESTRICT"i / "CASCADE"i

  createView =
    ( "CREATE"i / "DECLARE"i) __ orReplace (viewType __?)* "VIEW"i __ ifNotExists n:name (_ columnNameList)?
    __ "AS"i _ fullSelect
    (_ tableOption ( (__ / _ ',' _) tableOption)*)? _ 

  viewType = "MATERIALIZED"i / "SECURE"i / "TEMPORARY"i

  createType = "CREATE"i __ orReplaceMatch ("DISTINCT"i __)? (a:"TYPE"i {return o.toPostgres?"DOMAIN":a}/"DOMAIN"i) 
    __ ifNotExists name __
    "AS"i __
    (  "ROW"i ( (__ "ANCHOR"i __ "ROW"i __ "OF"i __ name) / tableDefintion )
      / type
    )
  dropType = "DROP"i __ ("DISTINCT"i __)? (a:"TYPE"i {return o.toPostgres?"DOMAIN":a}/"DOMAIN"i) ifExists __ name

  createSchema = "CREATE"i __ orReplace "SCHEMA"i __ ifNotExists name 
  createSequence = "CREATE"i  __ orReplace "SEQUENCE"i __ ifNotExists name (__ basicTypeName)? ( __ sequenceOption)*
  sequenceOption =
      ("START"i (__ "WITH"i)?/ "INCREMENT"i __ "BY"/ "MINVALUE"i / "MAXVALUE"i / "CACHE"i)  __ number
    / ("NO"i __)? ("MINVALUE"i / "MAXVALUE"i / "CYCLE"i / "CACHE"i / "ORDER"i)

  createVariable = "CREATE"i orReplace __ "VARIABLE"i __ ifNotExists name __ type

  createTrigger = "CREATE"i  orReplace __ "TRIGGER"i __ ifNotExists name
    __ (("NO"i __  "CASCADE"i __ )? "BEFORE"i / "AFTER"i / "INSTEAD"i __ "OF"i )
    __ triggerEvent (__ "OR"i __ triggerEvent)*
    __ "ON"i __ name
    ( __ "REFERENCING"i (__ ("OLD"i/"NEW"i) __ ("AS"i __) name)+)?
    ( __ "FOR"i __ "EACH"i __ ("ROW"i/"STATEMENT"i))?
    ( __ ("NOT"i __)? "SECURED"i)?
    ( __ "WHEN" __ '(' _ expression _ ')')?
    __ statement

  triggerEvent = "INSERT"i / "DELETE"i / "UPDATE"i (__ "OF" __ columnNames)?

  createTable = 
    ( "CREATE"i / "DECLARE"i ) __ orReplaceMatch (tableType __?)* 
    "TABLE"i __ ifNotExists n:name &{ scratch.table=concatText(n);return 1} 
    (_ tableDefintion)?  // can have either a tableDefintion, an AS or both (but not none)
    ( _ "AS"i _ fullSelect)? 
    (_ tableOption ( (__ / _ ',' _) tableOption)*)? _ 
    //  ignore_until_next  // would be good to fix this rather than have to parse all possible table options!
    &{cat.tables.push(scratch.table);cat.columns.push(scratch.columns);resetSctatch();return 1}

  tableType = "TEMP"i ("ORARY"i)? / "GLOBAL"i / "LOCAL"i / "PRIVATE"i / "UNLOGGED"i / "EXTERNAL"i / "SNAPSHOT"i / "SHARDED"i / "DUPLICATED"i / "IMUTABLE"i / "BLOCKCHAIN"i / "HYBRID"i

  tableDefintion = 
    "(" _ (createTableLike/tableColumns) _ ")"
  / createTableLike

  createTableLike = 
    a:(("LIKE"i / "CLONE"i )) 
    b:(__ identifier)
    c:(__ ("INCLUDING"i/"EXCLUDING"i) __ ("DEFAULTS"i/"CONSTRAINTS"i))*
    { return o.convert && o.toPostgres
      ? [].concat('AS TABLE',b,' WITH NO DATA')
      : [].concat(a,b,c)
    }

  tableColumns = tableColumn (_ "," _ tableColumn)*

  tableColumn = constraint / c:identifier __ type (__ columnOption)* &{scratch.columns.push([scratch.table,concatText(c)]);return 1}

  columnOption = 
      columnConstraint
    / collate
    / "GENERATED"i __ ("ALWAYS"i / "BY"i __ "DEFAULT"i) __ "AS"i __ columnGeneration
    / "IDENTITY"i  ( __ "START"i __ "WITH"i __ number )? (__ "INCREMENT"i __ "BY"i __ number)?
    / "COMMENT"i __ string
    / "HIDDEN"i
    / "STORED"i
    / "DISTKEY"i
    / "FAFAF"i
    / "SORTKEY"i
    / ("WITH" __)? "DEFAULT"i __ expression
    / "COMMENT"i __ string
    / "AUTO_INCREMENT"i

  columnConstraint = "NULL"i / "NOT"i __ "NULL"i (__ "ENABLE"i)?
    / constraint

  columnGeneration = 
      "ROW"i __ ("START"i / "END"i ) 
    / "IDENTITY"i ( _ '(' _ identityOption (_ (',' _)? identityOption)* ')' )?
    
  identityOption =
      "START"i __ "WITH"i __ number
      / "INCREMENT"i __ "BY"i __ number
      / "NOCACHE"i
      / "CACHE"i __ number

  constraint =
    ("CONSTRAINT"i (__ identifier)? __)? 
          (  "PRIMARY"i __ "KEY"i   ( _ columnNameList )?
          /  ("FOREIGN"i __ "KEY"i (__ identifier)? ( _ columnNameList )? __)? "REFERENCES"i __ name ( _ columnNameList )? (_ referentialOptions)?
          /  "UNIQUE"i (__  "NULLS"i __ ("NOT"i __)? "DISTINCT"i)?
          /  "CHECK"i _ "(" _ expression _ ")" (__ "NO"i __ "INHERIT"i)?
          )
      ( __ (indexOption / constraintOption))*

  constraintOption =
      ("NOT"i? __ ( "ENFORCED"i / "DEFERRABLE"i ))
    / "INITIALLY"i __  ( "DEFERRED"i / "IMMEDIATE"i)
    / ( "ENABLE"i / "DISABLE"i ) 
    / ( "VALIDATE"i / "NOVALIDATE"i )
    / ( "RELY"i / "NORELY"i )


  indexOption = a:(("CLUSTERED"i __)? "(" _ orderExpressionList _ ")" _ ("WITH"i _ "(" optionsList ")")? (_ filegroup)? )
    { return o.convert && o.eatIndexOptions 
      ?  ''
      : a
    }

  optionsList = nameEqValue ( _ "," _ nameEqValue)*
  nameEqValue = name _ "=" _ setValue
  filegroup = "ON"i __ name

  referentialOptions = ("MATCH"i __ ("FULL"i / "PARTIAL"i / "SIMPLE"i ))? 
                        "ON"i __ ("DELETE"i/"UPDATE"i/"INSERT"i)  __ referentialAction
  referentialAction = "NO"i __ "ACTION"i / "RESTRICT"i / "CASCADE"i / "SET"i __ "NULL"i / "SET"i __ "DEFAULT"i

  tableOption = "PARTITION"i __ "BY"i  (__ ("RANGE"i/"HASH"i))? _ '(' _ expressions _ ')' 
        / ( "DISTRIBUTE"i __ "BY"i / "DISTKEY"i / "CLUSTER"i "ED"i? __ "BY"i )  ( _ columnNameList / "RANDOM"i )
        /  "DISTSTYLE"i __ ( "AUTO"i / "EVEN"i / "KEY"i / "ALL"i ) 
        / ( "COMPOUND"i / "INTERLEAVED"i )? ("SORTKEY"i / "SORTED"i __ "BY"i) ( _ "(" _ orderExpressionList _ ")" / "AUTO"i )
        / "ORGANIZE"i __ "BY"i ( "ROW"i / "COLUMN"i ) (__ "USING"i)? (__ "DIMENSIONS"i)? ( _ columnNameList )?
        / "ENCODE"i __ "AUTO"i
        / "BACKUP"i ( "YES"i / "NO"i )
        / "WITHOUT"i __ "ROWID"i
        / "STRICT"i
        / "TABLESPACE"i __ identifier
        / filegroup (__ "TEXTIMAGE_ON [PRIMARY]"i )?  {return ''} // TODO make this SQL Server clause more generic
        / "ON"i __ "COMMIT"i __ ( ("PRESERVE"i / "DELETE"i) __ "ROWS"i  / "DROP"i )
        / "STORED"i __ "AS"i __ identifier
        / "LOCATION"i __ string ( __ "WITH" _ "(" _ "CREDENTIAL"i __ name _  ")")?
        / "COMMENT"i __ string
        / ( "OPTIONS"i / "TBLPROPERTIES"i/ "WITH"i ) _ "(" _ properties _ ")"?
        / "DEFAULT"i__ collate

  //Q do we want a catch all here. as there are thousands of table options accross the various DBMSes.

  columnNameList = "(" _ columnNames  _ ")"
  columnNames = sqlIdentifier (_ ',' _ sqlIdentifier)*

  properties = property ((_/_","_) property)*
  property = (identifier/literal) _ ("=" _)? literal 

  alterTable =
    "ALTER"i __ "TABLE"i __ name __
    ( ( 'ADD'i __ ("CONSTRAINT" __ (name __)?)? constraint )
    / ( 'ADD'i __ "COLUMN" __ name __ tableColumn )
    )+

  createIndex = a:(
    "CREATE"i __ ("UNIQUE"i __)? "INDEX"i __ ("CONCURRENTLY"i __)? ifNotExists name __
    "ON" __ ("ONLY"i __)? name ("USING" __ name)?
    ( __ name /  _ '(' _  expression _ ')' )
      // } [ COLLATE collation ] [ opclass [ ( opclass_parameter = value [, ... ] ) ] ]
    ( __ orderOption)*
    (__ "INCLUDE"i _ columnNameList )?
      // [ NULLS [ NOT ] DISTINCT ]
      // [ WITH ( storage_parameter [= value] [, ... ] ) ]
      // [ TABLESPACE tablespace_name ]
      ( __ "WHERE" __ expression)?
      skipUntilDelimiter
  ){ return o.convert && o.eatIndexes ? "" : a}

  // 88""Yb 88""Yb  dP"Yb   dP""b8 .dP"Y8 
  // 88__dP 88__dP dP   Yb dP   `" `Ybo." 
  // 88"""  88"Yb  Yb   dP Yb      o.`Y8b 
  // 88     88  Yb  YbodP   YboodP 8bodP' 

  sqlServerStatement = compoundStmt / sqlStmt

  compoundStmt = 
    &{return o.fromDb2 } db2Block
  / &{return o.fromMSSQL} try
  / &{return o.fromMSSQL} msBlock 
  / &{return o.fromMSSQL} "BEGIN"i __ (("ATOMIC"/"NOT"i __"ATOMIC") __)? msStmts __ "END"i
  / beginTransaction
  / "BEGIN"i __ (("ATOMIC"/"NOT"i __"ATOMIC") __)? sqlStmts _ "END"i

  sqlStmts = sqlStmt _ stmtDelimiter (_ sqlStmt _ stmtDelimiter)*
  msStmts = msStmt ( __ msStmt)*  //SQL Server allows statment delimeters to be optional :-(  so add them in if not used and we haven't blanked out a statement
  msStmt = a:sqlServerStatement  b:(_ stmtDelimiter)? { return o.convert && a && a[0] && ! b ? [].concat(a,o.stmtDelimiter) : [].concat(a,b) }

  beginTransaction = "BEGIN"i __ "TRAN"i "SACTION"i? //(__ name)? (__ "WITH"i __ "MARK" (__ string)?)?  // need to add a NOT KEYWORD to the name match if want to support named transactions
  commit = "COMMIT"i (__ "TRANSACTION"i {return o.toSnowflake?"":text()})?
  rollback = "ROLLBACK"i (__ "TRANSACTION"i {return o.toSnowflake?"":text()})?
  throw = "THROW"i

  try = a:("BEGIN"i__) b:("TRY"i __) c:msStmts d:(__ "END"i) e:(__ "TRY"i  __ "BEGIN"i__ "CATCH"i  __ msStmts __ "END"i __ "CATCH"i)
    {return o.toSnowflake ? [].concat(a,c,d) : [].concat(a,b,c,d,e) } // assume the catch is redundant for the moment!

  msBlock =  // this is tuned for SQL Server to Snowflake conversion. 
  // It (will)
  // Strip line level DECLARE, replace with a DECLARE section 
    a:("BEGIN"i)?
    b:(__ ("ATOMIC"/"NOT"i __"ATOMIC"))?
    bb:(__ msSQLSet)*  
    c:(__ declare (_ stmtDelimiter)?)* 
    d:(__ declareHandler (_ stmtDelimiter)?)* 
    e:(__ msStmts) 
    f:(__ return _ stmtDelimiter)? 
    g:(__ "END"i (__ ("PROCEDURE"i/"FUNCTION"i))?)
      { //blockHasNotFoundHandler=false;
        return ( 
          o.convert && ! o.toMSSQL ?
            [].concat( 
                ( c && c[0] ? [].concat("DECLARE ",c, c[0][0]) :"") 
                ,a,b,bb,e,d,f,g) 
          : [].concat(a,b,bb,c,d,e,f,g)
          )
      } 

  db2Block =  // this is tuned for Db2 to Postgres conversion
    a:("BEGIN"i)
    b:(__ ("ATOMIC"/"NOT"i __"ATOMIC"))? 
    c:(__ r:declare )* 
    d:(__ declareHandler _ ';')* 
    e:(__ sqlStmt _ ';' )+ 
    f:(__ return _ ';')? 
    g:(__ "END"i (__ ("PROCEDURE"i/"FUNCTION"i))?)
    { blockHasNotFoundHandler=false;
      return o.convert && o.toPostgres 
        ? [].concat(c?[].concat("DECLARE ",c,c[0]?c[0][0]:""):"" ,a,b,e,d,f,g)
        : [].concat(a,b,c,d,e,f,g)
    } 

  // This is rather tuned to Db2 SQL PL language, and targeting Postgres. 
  //  To make it more generic, would make it more difficult to do things move and convert preceeding condition handlers to trailing exception clauses
  createProc =
    "CREATE"i __ orReplace ("PROCEDURE"i/"FUNCTION"i) __ ifNotExists n:name
    ( a:( _ '(' _ procDefintion? _ ')')? {return o.convert && o.toSnowflake && ! a  ? "()" : a} ) 
    ( a:(__ createProcOption)*           {return o.convert && o.toSnowflake && ! a.length ? " returns int " : a} )
    ( _ "AS"i) ?
    ( a:_ {{return o.convert && o.toEDB ? [].concat(" AS $proc$",a) : a }}  ) 
    statement
    ( a:_ {{return o.convert && o.toEDB ? [].concat(a,"$proc$\n") : a }}  )
  createProcOption =
      "LANGUAGE"i __ lang
    / "SPECIFIC"i __ name {return o.convert && o.toPostgres?"":text()}
    / ("DYNAMIC"i __)? "RESULT"i "S"i? __ "SETS"i __ number {return o.convert && o.toPostgres?"":text()}
    / ("MODIFIES"i/"READS"i) __ "SQL"i __ "DATA"i {return o.convert && o.toPostgres?"":text()}
    / (("NO"i __)? "EXTERNAL"i  __ "ACTION"i) {return o.convert && o.toPostgres?"":text()}
    / "CONTAINS"i/ __ "SQL"i {return o.convert && o.toPostgres?"":text()}
    / ("NOT"i __)? "DETERMINISTIC" {return o.convert && o.toPostgres?"":text()}
    / "CALLED"i __ "ON"i __ "NULL"i __ "INPUT" {return o.convert && o.toPostgres?"":text()}
    / "RETURNS"i __ ( "TABLE"i _ "(" _ tableColumns _ ")" / type )
    / "RETURNING"i __ procReturningDefintion _ ';'
  lang = "SQL"i { {return o.convert && o.targetLang ? o.targetLang : text()}  } 

  procDefintion = paramDefintion (_ ',' _  paramDefintion)*
  paramDefintion = (paramType __)? name __ type (__ "DEFAULT" __ expression)? (__ paramType)?
  paramType = ("INOUT"i / "IN"i "PUT"i? / "OUT"i "PUT"i?) {return o.convert && o.toSnowflake?"":text()}

  procReturningDefintion = type (_ ',' _  procReturningDefintion)*

  declare = // All DECLAREs apart from Handlers https://www.ibm.com/docs/en/db2/11.5?topic=statements-compound-sql-compiled#sdx-synid_frag-condition-declaration
      declareCursor _ ';'
    / declareCondition
    / declareVariable _ ';'

  declareCondition = a:("DECLARE"i __ name __ "CONDITION"i __ "FOR"i __ ("SQLSTATE"i __ ("VALUE"i __)?)? string (_ ';')?)
     {return o.convert && o.toPostgres ? '' : a } // postgres does not have a method to name conditions 

  // in Db2 you can declare more than one variable in a single DECLARE. You can't do this in e.g. Postgress, so we will need to duplicate each. 
  declareVariable  = a:("DECLARE"i/"DEFINE"i) b:(__ name) c:( _ ',' _ name)* d:(__ type (_ ("="/"DEFAULT"i) _ ( expression / subExpression ))? )
    { return  o.convert && ! o.toDb2 
      ? [].concat(b, d, c.map(el => [el[0],';\n  ',b[0],el.slice(2,4),d]) ) 
      : [].concat(a,b,c,d)
    }

  // https://www.ibm.com/docs/en/db2/11.5?topic=statements-compound-sql-compiled#sdx-synid_handler-declaration
  declareHandler   =  
    a:("DECLARE"i __ )
    b:("CONTINUE"i/"EXIT"i/"UNDO"i)
    c:( __ "HANDLER"i __ "FOR"i) 
    d:(__ declareHandlerCondition (_ ',' _ declareHandlerCondition)*) 
    e:(__ sqlStmt)? 
    { return o.convert && o.toPostgres 
      ? [].concat('EXCEPTION WHEN', d, ' THEN', e, b.toUpperCase()==='EXIT' ? '; return' : '') // turn condition handlers into EXCEPTION claueses 
      : [].concat(a,b,c,d,e)
    }

  declareHandlerCondition = 
      ("SQLEXCEPTION"i   {return o.convert && o.toPostgres?"OTHERS":text()}  // (in Db2) An exception condition is represented by an SQLSTATE value whose first two characters are not '00', '01', or '02'.
      / "SQLWARNING"i    // (in Db2) A warning condition is represented by an SQLSTATE value whose first two characters are '01'.
                        //  (in DB2)  A NOT FOUND condition is represented by an SQLSTATE value whose first two characters are '02'.
      /  "NOT"i __ "FOUND"i {blockHasNotFoundHandler=true; return o.convert && o.toPostgres ? 'raise_exception' : text() }  // Postgres does not raise exceptions for not found, so need to add excpetions and catch them here
        )  // general condition
    / ("SQLSTATE"i __ ("VALUE" __)? string)  // specifc condition
    / "CONDITION"i __ "FOR"i __"SQLSTATE"i __ "VALUE"i __ string
    / (a:simpleName {return o.convert && o.toPostgres && a == 'not_found' ? 'raise_exception' : a } )// map Db2 to Postgres condition names. TODO to add more


  // Postgres RAISE command : https://www.postgresql.org/docs/14/plpgsql-errors-and-messages.html
  signal = ("SIGNAL"i {return o.convert && o.toPostgres ? "RAISE":text()}) __ "SQLSTATE"i __ ("VALUE"i __ {return o.convert && o.toPostgres?"":text()})? ( string / identifier )
  ( __  ( '(' _  ( string / identifier ) _ ')') 
      / ( a:__ b:"SET"i c:__ d:"MESSAGE_TEXT"i e:(_ '=' _) f:( string / identifier )  
          {return o.convert && o.toPostgres ? [].concat(a,"USING MESSAGE",e,f) : [].concat(a,b,c,d,e,f) }
          ) 
  )?

  declareCursor =  (a:"DECLARE"i {return o.convert && o.toPostgres?"":a}) __ cursor __
    (a: ("WITH"i "OUT"i? __ "RETURN" __ ("TO" __ ("CLIENT"i/"CALLER"i) __)?)? {return o.convert && o.toPostgres?"":a} )?
    "FOR"i __ fullSelect

  cursor = simpleName __ (("A"i/"IN"i)"SENSITIVE"i __)? "CURSOR"i (__  "WITH"i "OUT"i? __ "HOLD")? 

  openClose = ("OPEN"i/"CLOSE"i) __ simpleName
  fetch = "FETCH"i __ ("FROM"i __)? simpleName __ "INTO"i __ name (_ ',' _ name)*

  return = "RETURN"i__ (fullSelect / columnNames)

  prepareAndExecute = &{return o.convert && o.toPostgres} a:("PREPARE"i __ name __ "FROM" __) b:name c:(_ stmtDelimiter _) d:("EXECUTE"i __) e:name f:(__ "USING"i __ columnNames)?
      {return [].concat(d,b,f)} //eat PREPARE and move variable into the EXECUTE
      
  prepare = "PREPARE"i __ name __ "FROM" __ name
  execute = "EXECUTE"i __ name (__ "USING"i __ columnNames)?

  setVariable = 
    &{return o.convert && o.toEDB} 
    a:("SET"i __) b:("stmt"i _                   ) c:"=" d:(_  expression) {return           [].concat(b,':=',replaceParamMarkers(concatText(d))) } //change ? into $1 etc when use in "stmt" variables
  / a:("SET"i __) b:(name    _ (subPartorCast _)?) c:"=" d:(_  expression) {return o.convert && o.toPostgres ? [].concat(b,':=',d) : [].concat(a,b,c,d) }

  getDiagnostics = 
    "GET"i __ "DIAGNOSTICS"i a:(__ name _) "=" b:(_  expression) 

  if =
    "IF"i __ expression __ "THEN" __ sqlStmts
    (_ "ELSEIF"i __ expression __ "THEN"i __ sqlStmts)*
    (_"ELSE"i __ sqlStmts)?
    _ "END"i __ "IF"i

  iterator = (a:simpleName b:":" c:__ {return o.convert && o.toPostgres?[].concat("<<",a,">>",c):[].concat(a,b,c)})?
    (loop / while / repeat / for) (__ simpleName)?
  while = "WHILE"i __ expression __ (a:"DO"i {return o.convert && o.toPostgres?'LOOP':a}) __ sqlStmts _ "END"i __ (a:"WHILE"i {return o.toPostgres?'LOOP':a} )
  loop = "LOOP"i __ sqlStmts _ "END"i __ "LOOP"i

  repeat = a:"REPEAT"i b:(__ sqlStmts _) c:"UNTIL"i d:(__ expression) e:(__ "END"i __) f:"REPEAT"i
    {return o.convert && o.toPostgres ? [].concat('LOOP',b,'IF',d,' THEN EXIT; END IF;',e,'LOOP') : [].concat(a,b,c,d,e,f)} 

  for = "FOR"i __ name __ "AS"i __ cursor __ "FOR"i _ '(' _ fullSelect _ ')' __ "DO"i __ stmts _ "END"i __ "FOR"i


  leaveIterate =
    ( (a:"LEAVE"i   {return o.convert && o.toPostgres?'EXIT':a})
    / (a:"ITERATE"i {return o.convert && o.toPostgres?'CONTINUE':a})
    ) __ simpleName
    

  // .dP"Y8 888888 88     888888  dP""b8 888888 
  // `Ybo." 88__   88     88__   dP   `"   88   
  // o.`Y8b 88""   88  .o 88""   Yb        88   
  // 8bodP' 888888 88ood8 888888  YboodP   88   

  fullSelect = setStatement / valuesExpression / '(' _ setStatement _ ')'
  setStatement = selectMaybeNested
      (_ ("UNION"i/"INTERSECT"i/"MINUS"i/"EXCEPT"i) (__ ("ALL"i/"DISTINCT"i))? _ selectMaybeNested)*
  selectMaybeNested = select / '(' _ select _ ')' 


  valuesExpression =  'VALUES'i _ values
  values = valuesRow (_ ',' _  valuesRow)*  ( _ valuesAlias)?
  valuesRow = expression / '(' _ expressions _ ')'
  expressions = a:expression b:(_ ',' _ expression)*
  valuesAlias = "AS"i __ sqlIdentifier (_ nameList)?
                / notAlias _ sqlIdentifier (_ nameList)?

  valuesStmt = 
    a:"VALUES"i
    b:(_  values ( _ "INTO"i __ name)?)
    { return o.convert && ! o.toDb2
      ? [].concat('SELECT',b) 
      : [].concat(a,b)
    }

  select = 
    w:(with _)?
    a:"SELECT"i
    c1:(__ ("ALL"i/ "DISTINCT"i))?
    b:(__ top)? 
    c21:_ws c22:(star _ "," )? // an unaliased select * with other columns selected
    c3:(_fl columnExpressionList)
    c41:_ws c42:(star _ws (  "," _ columnExpressionList) ?)?  // an unaliased select * within other columns selected
    i:(_ "INTO"i __ name (_ ',' _ name)*)?
    d:( _nl from / nonSql )?
    e:( 
      (_i sample)?
      (_i where)?
      (_i groupBy)?
      (_i having)?
      (_i qualify)?   // Snowflake and others have this
      (_i distributeBy)? // a Databricks'ism
      (_i sortBy)?       // a Databricks'ism
      (_i clusterBy)?    // a Databricks'ism
      (_i orderBy)?
    )
    f:(_ limit)?
    g:(_ option)?
    { return o.top_to_limit && b !== null  // move any TOP down the the LIMIT/ FETCH FIRST section, also add subselect aliases if needed.
      ? [].concat(w,a,  c1,c21,(o.name_ss && c22 !== null)?["SS."].concat(c22):c22,c3,c41,(o.name_ss && c42 !== null)?["SS"].concat(c42):c42,i,(d === null && o.add_from_dummy_table)? " FROM "+o.dummyTableName+" ":d,e," "+o.limit_expression+" "+b[1].v+o.limit_expression_postfix," ",g)
      : [].concat(w,a,b,c1,c21,(o.name_ss && c22 !== null)?["SS."].concat(c22):c22,c3,c41,(o.name_ss && c42 !== null)?["SS"].concat(c42):c42,i,(d === null && o.add_from_dummy_table)? " FROM "+o.dummyTableName+" ":d,e,f,g)
    }   

  with = "WITH"i __ ("RECURSIVE"i __)? sqlIdentifier (_ nameList)? _ "AS"i _ withBody
  withBody = '(' _ fullSelect _ ')' (_ ',' _ sqlIdentifier nameList? _ "AS"i _ '(' _ fullSelect _ ')')*
  nameList = '(' _ sqlIdentifier (_ ',' _ sqlIdentifier)* _ ')'

  star = '*' (__ "EXCEPT"i _ nameList)?

  // todo, merge this TOP clause with the SELECT to avoid needeing to pass back a structured value?
  top = "TOP"i ___  e:expression (__ "PERCENT"i)? (__ "WITH" __ "TIES")? 
    { return { n:'top', v:concatText(e), t:text() }} // we seperate out the expression so we can use it when moving the TOP expression to a LIMIT 

  from = "FROM"i ___ fromClause (_ ',' _ fromClause)*
              // the from list WAS optional as a "catch all" to avoid adding FROM DUAL if we fail to correctly parse the FROM conditions
  fromClause =
        '(' _ valuesExpression _')' ( _ valuesAlias)?    // am I correct that we can have alias outside and inside VALUES calues?
      / valuesExpression
      / fromList
      / '(' _ fromList _')'

  sample =
      ("USING" __)? 
      ("TABLESAMPLE"i/"SAMPLE"i) 
      (__ sampleMethod / _ '(' _ sampleMethod _ ')' )? 
      (__ "REPEATABLE"i/"SEED" _ number / ('(' _ number _ ')') ) ? 
  sampleMethod = ("BERNOULLI"i/"ROW"i/"SYSTEM"i/"BLOCK"i)? _ ( sampleSize / '(' _ sampleSize ')')
  sampleSize = (number (_ "%" / __ ("PERCENT"i/"ROWS"i))? (_ ',' _ number _ )? )
      / ("BUCKET" __ number __ "OUT"i __ "OF"i __ number (__ "ON"i __ expression)?)

  where = "WHERE"i ___ functionExpressionList
  groupBy = "GROUP"i __ "BY"i ( (__fl groupingSets)+ / __fl columnExpressionList (_ (',' _)? groupingSets (__ groupingSets)*)?)
  groupingSets = ("GROUPING"i __ "SETS"i / "CUBE"i / "ROLLUP"i) _ '(' _ columnExpressionList _ ')'
  having  = "HAVING"i  ___fl functionExpressionList
  qualify = "QUALIFY"i ___fl functionExpressionList
  distributeBy = "DISTRIBUTE"i __ "BY"i __fl orderExpressionList
  sortBy       = "SORT"i       __ "BY"i __fl orderExpressionList
  clusterBy    = "CLUSTER"i    __ "BY"i __fl orderExpressionList
  orderBy = "ORDER"i __ ("SIBLINGS"i __)? "BY"i __fl orderExpressionList
  limit = 
        ( "LIMIT"i __ number (__ "OFFSET"i __ number)?)
      / ( ("OFFSET"i __ number __ "ROW"i "S"i? _)? "FETCH"i __ ("FIRST"i/"NEXT"i) __ number __ "ROW"i "S"i? __ "ONLY"i )
  option = "OPTION"i // ( <query_option> [ ,...n ] ) ]
    / "FOR"i __ "UPDATE"i  __ "OF" __ name

  // TODO. match only table references that are likley to be source tables.
  //   We could assume that say 2, 3 or 4 part names are table references
  //     We could assume that names less than 4 characters are alias references
  //     We could allow a custom functin that determins if a given name is or is not to be replaced for a given customer
  //        we could pass such functions in to a call of our parser (and the names might haven been generated from e.g. a source catalog...)
  //        In other words we can do most ot the things that a humam does short of doing full name resolution by reading the parse tree and following DBMS scoping rules!
  tableRef = tableFunction (__ tableFunctionOptions)*
   / &{return o.convert && o.fromDb2 && ! o.toDb2} "SYSIBM.SYSDUMMY1"i {return "DUAL"} 
   / name

  fromList =   // TODO tidy up this
          (((tableRef) (__ tableAlias)?) / (subSelect (_ tableAlias)?)) _ ',' _ fromList
        / (((tableRef) (__ tableAlias)?) / (subSelect (_ tableAlias)?)) (__ joinInfix __ (((tableRef) (__ tableAlias)?) / (subSelect (_ tableAlias)?)) (__ joinPostfix)?)+
        / (((tableRef) (__ tableAlias)?) / (subSelect (_ tableAlias)?)) 
  tableFunction =
          ("FINAL"i/"NEW"i/"OLD"i) __ "TABLE"i _ '(' _ statement _ ')'   // a SQL data change statement   -- https://www.ibm.com/docs/en/db2/11.5?topic=statement-result-sets-from-sql-data-changes
        / (("TABLE"i / ("LATERAL"i (__ "VIEW"i)? (__ "OUTER"i)? )) (__ function / (_ '(' _ function _  ')' ))) 
        / function

  tableFunctionOptions = "WITH"i __ "ORDINALITY"i   // this is a Db2 ism on e.g. UNNEST

  joinInfix = ("NATURAL"i __)? (("LEFT"i/"RIGHT"i/"FULL"i) __)? (("OUTER"i/"INNER"i/"SEMI"i/"ANTI"i/"CROSS"i) __)? "JOIN"i
  joinPostfix = ("ON"i / "USING"i) _  booleanExpression

  tableAlias  = 
    a:("AS"i) b:__ c:sqlIdentifier  d:(_ nameList)?
    { return o.convert && o.eat_AS_on_tableAlias
      ? [].concat(c,d) 
      : [].concat(a,b,c,d)
    }
    / notAlias sqlIdentifier (_ nameList)?

  columnAlias = r:("AS"i __ sqlIdentifier 
              / notAlias sqlIdentifier      )   { return { n:'tableAlias', t:text(), s:concatText(r) }  }

  notAlias = // used to disambiguate where we have e.g. "FROM A LEFT JOIN B" we need to not treat LEFT as an alias for A 
      !("INTO"i/"ON"i/"USING"i/"LEFT"i/"RIGHT"i/"FULL"i/"OUTER"i/"INNER"i/"NATURAL"i/"SEMI"i/"ANTI"i/"CROSS"i/"JOIN"i
        /"FROM"i/"WHERE"i/"GROUP"i/"HAVING"i/"ORDER"i/"OPTION"i/"LIMIT"i/"FETCH"i/"OFFSET"i/"QUALIFY"i
        /"UNION"i/"EXCEPT"i/"INTERSECT"i/"MINUS"i
        /"DISTRIBUTE"i/"CLUSTER"i/"SORT"i
        /"TABLESAMPLE"i/"SAMPLE"i/"WITHIN"i
        /"LATERAL"i/"TABLE"i
        /"ASC"i/"DESC"i  // maybe should be more sepecifc about when I'm looking forward to allow more unquoted keywords
        /"FOR"i  // e.g. as in SQL Server's "FOR XML PATH"
        )

  columnExpressionList   = 
      &{return o.non_sql} nonSql _ commaSep? _ columnExpressionList
    / columnExpression (expCommaSep columnExpression)*

  columnExpression = expression (_ columnAlias)?  // TODO will the optional whitespace cause this to "over match" sometimes?
    / '(' _ ')'  // empty expression used by grouping sets

  orderExpressionList =  orderExpression (commaSep orderExpression)*
  orderExpression = expression orderOption?

  orderOption = 
    a:(__ ( "ASC"i / "DESC"i ))?  b:( __ "NULLS"i __ ("FIRST"i/"LAST"i))?
    { return o.convert && o.injectNullOrder && ! b 
      ? [].concat(a,' ',o.nullOrder) 
      : [].concat(a,b)
    }

  functionExpressionList = // TO test . is this working in all cases?
    defaultParams (functionExpressionList)*
    / name _ namedParamArrow _ expression ( defaultParams / commaSep functionExpressionList)* //named parameter
    /                          expression ( defaultParams / commaSep functionExpressionList)* //unnamed parameter
  defaultParams = a:( (_ ',' _)? (name _ namedParamArrow _) "DEFAULT"i (_ ',' _)? )
    { return o.convert && o.eatDefaultNamedParam
      ? ""
      : a
    }
  namedParamArrow = '=>' / ':=' {return o.convert ? "=>" : text() } // := is a older (non SQL Standard) Postgres style

  function =
      specialRegisters / case / iif / left / right / to_char_formatted / decode / to_char
    / datetimeExtract
    / datetimeFunctions / eomonth /dateAdd / dateDiff
    / toTypeFunc / typeFunc  
    / stuffXml / xmlAggToStringAgg / stuff / convert / concat / paramFunction / emptyParamFunction

  paramFunction =
    a:name
    b:(_ '(' _ functionExpressionList _ ( functionOptions _)? ')') 
    c:(__ functionPostfix)?
    { if(o.analyze) el.funcs.push(concatText(a)); 
    return o.convert
    ? [].concat(o.mapFunctionName(concatText(a)),b,c) 
    : [].concat(a,b,c)
    }

  emptyParamFunction =
    a:name
    b:(_ "(" _ ")")
    { if(o.analyze) el.funcs.push(concatText(a)); 
    return o.convert
    ? [].concat(o.mapFunctionName(concatText(a)),b) 
    : [].concat(a,b)
    }

  functionOptions = "IGNORE"i __ "NULLS"i
    / orderBy


  // "Ordered-Set Aggregate Functions" - https://www.postgresql.org/docs/15/functions-aggregate.html#FUNCTIONS-ORDEREDSET-TABLE
  functionPostfix =
    "WITHIN"i __ "GROUP"i _ '(' _ orderBy _ ')'
  / "FILTER"i _ '(' _ where _ ')'   // //  add FILTER clauses https://www.postgresql.org/docs/14/sql-expressions.html#SYNTAX-AGGREGATES


  cast = ("CAST"i/"TRY_CAST"i) _'(' _ expression _ 'AS'i _ castType _ ')'

  case = "CASE"i               __ whenBoolean    (__ whenBoolean)*    (__ "ELSE"i __ then)? __ "END"i (__ "CASE"i)?
      / "CASE"i __ expression __ whenExpression (__ whenExpression)* (__ "ELSE"i __ then)? __ "END"i (__ "CASE"i)?
  whenBoolean =    "WHEN"i __ booleanExpression __ "THEN"i __ then
  whenExpression = "WHEN"i __        expression __ "THEN"i __ then 
  then = ( sqlStmts / expression )  // allow statments not just expressions to match CASE as used in Procedural SQL

  olap = olapFunc 
    _ '(' _ "DISTINCT"i? 
    _ (expression _ (_ ',' _ expression _)* )? ')' 
    (_ 'OVER'i _ '(' _ overClause* _ ')')?
    (__ functionPostfix)?
  overClause =  ( partitionBy / orderBy / window ) __ overClause
              / ( partitionBy / orderBy / window )
  olapFunc = a:('AVG'i/'ARRAY_AGG'i/'CLUSTER_DETAILS'i/'CLUSTER_DISTANCE'i/'CLUSTER_ID'i/'CLUSTER_PROBABILITY'i/'CLUSTER_SET'i/'CORR'i/'COUNT'i/'COUNT_IF'i/'COVAR_POP'i/'COVAR_SAMP'i/'CUME_DIST'i/'DENSE_RANK'i
      /'FEATURE_DETAILS'i/'FEATURE_ID'i/'FEATURE_SET'i/'FEATURE_VALUE'i/'FIRST'i/'FIRST_VALUE'i/'LAG'i/'LAST'i/'LAST_VALUE'i/'LEAD'i/'LISTAGG'i/'MAX'i/'MIN'i/'NTH_VALUE'i/'NTILE'i
      /'PERCENT_RANK'i/'PERCENTILE_CONT'i/'PERCENTILE_DISC'i/'PREDICTION'i/'PREDICTION_COST'i/'PREDICTION_DETAILS'i/'PREDICTION_PROBABILITY'i/'PREDICTION_SET'i/'RANK'i/'RATIO_TO_REPORT'i
      /'ROW_NUMBER'i/'ROW'i/'STDDEV'i/'STDDEV_POP'i/'STDDEV_SAMP'i/'SUM'i/'VAR_POP'i/'VARIANCE_POP'i/'VAR_SAMP'i/'VARIANCE'i/'VARIANCE_SAMP'i
      /'REGR_SLOPE'i/'REGR_INTERCEPT'i/'REGR_COUNT'i/'REGR_R2'i/'REGR_AVGX'i/'REGR_AVGY'i/'REGR_SXX'i/'REGR_SYY'i/'REGR_SXY'i)
    { if(o.analyze) el.funcs.push(a); 
      return o.convert
      ? o.mapFunctionName(a)
      : a
    }

  partitionBy = 'PARTITION'i __ 'BY'i __ functionExpressionList
  window =  ('ROWS'i / 'RANGE'i) __ 'BETWEEN'i __ windowBound __ 'AND'i __ windowBound
          / ('ROWS'i / 'RANGE'i) __  windowBound
  windowBound = ('CURRENT'i __ 'ROW'i) / ( (numberOrInterval / 'UNBOUNDED'i) (__ ('PRECEDING'i / 'FOLLOWING'i))? )


  //  dP""b8  dP"Yb  88b 88 Yb    dP 888888 88""Yb 888888 
  // dP   `" dP   Yb 88Yb88  Yb  dP  88__   88__dP   88   
  // Yb      Yb   dP 88 Y88   YbdP   88""   88"Yb    88   
  //  YboodP  YbodP  88  Y8    YP    888888 88  Yb   88   

  decode = 
    & {return o.decode_to_case}
    a:"DECODE"i
    b:_
    c:"("
    d:(_ expression _)
    e:","
    f:decodeWhenThens
    g:")"
    { return [].concat('CASE ',d,f,' END')
    }

  decodeWhenThens = a:decodeWhenThen b:(_ ',' _ @decodeWhenThen)* {return a.concat(b) }
  decodeWhenThen =
    a:(_ expression _)
    b:","
    c:(_ expression _)
    { return [].concat(' WHEN ',a,' THEN ',c) }

  doublePipe = "||" 
    { return o.convert && o.double_pipe_to_plus
      ? '+'
      : text()
    }

  to_char_formatted =
    a:"TO_CHAR"i
    b:_
    c:"("
    d:(_ expression _)
    e:","
    f:(_ string _)
    g:")"
    { if(o.analyze) el.funcs.push("TO_CHAR"); 
      return o.convert && o.to_char_to_format
      ? [].concat("FORMAT",b,c,d,e,f,g)  // TO ADD convertion from Oracle to MS SQL format strings.  e.g. HH24 -> ??
      : [].concat(a,b,c,d,e,f,g)
    }

  to_char =
    a:"TO_CHAR"i
    b:_
    c:"("
    d:(_ expression _)
    e:")"
    { if(o.analyze) el.funcs.push("TO_CHAR"); 
      return o.convert && o.to_char_to_cast
      ? [].concat("CAST",b,c,d," AS varchar",e)
      : [].concat(a,b,c,d,e)
    }

  iif =
    a:("IIF"i _ "(")
    b:(_ booleanExpression _)
    c:","
    d:(_ expression _)
    e:","
    f:(_ expression _)
    g:")"
    { if(o.analyze) el.funcs.push("IIF"); 
      return o.convert && o.iif_to_case
      ? [].concat("CASE WHEN ",b," THEN ",d, " ELSE ",f," END")
      : [].concat(a,b,c,d,e,g)
    }
    
    plusStringExpression = // convert + to || when used on string expressions
    &{return o.convert && (o.plus_to_double_pipe || o.greedy_plus_to_double_pipe) }  
    plusStringExpressionSeq

  plusStringExpressionSeq = // cherry pick certain sequences of expressions connected with "+" that are likly to need converting to ||
      a:(stringExpression _) '+' b:(_ plusStringExpressionSeq)    { return [a].concat([' || ']).concat(b) }
    / a:(stringExpression _) '+' b:(_ stringExpression)           { return [a].concat([' || ']).concat(b) }
    / &{return o.greedy_plus_to_double_pipe}
      a:(   baseExpression _) '+' b:(_ plusStringExpressionSeq)   { return [a].concat([' || ']).concat(b) }
    / a:(   baseExpression _) '+' b:(_      stringExpression)     { return [a].concat([' || ']).concat(b) }
    / a:( stringExpression _) '+' b:(_        baseExpression)     { return [a].concat([' || ']).concat(b) }

  // TODO consider using a JS function to guess is a function might be returning a date/time etc..  or query e.g. the SQL Server catalog and build up a list
  stringExpression = stringFunction / string
  stringFunction =
      !("DATEADD"i/"DATEDIFF"i/"DATEDIFF_BIG"i/"DATEPART"i/"DAY"i/"MONTH"i/"YEAR"i/"GETDATE"i/"GETUTCDATE"i
      /"CURRENT_TIMESTAMP"i/"CURRENT_TIMEZONE"i/"SYSDATETIME"i/"SYSDATETIMEOFFSET"i/"SYSUTCDATETIME"i
      /"DATEFROMPARTS"i/"DATETIMEFROMPARTS"i/"SMALLDATETIMEFROMPARTS"i/"SWITCHOFFSET"i
      "ABS"i/"ACOS"i/"ASIN"i/"ATAN"i/"ATAN2"i/"CEILING"i/"COS"i/"COT"i/"DEGREES"i/"EXP"i/"FLOOR"i/"LOG"i/"LOG10"i/"PI"i/"POWER"i/"RADIANS"i/"RAND"i/"ROUND"i/"SIGN"i/"SIN"i/"SQRT"i/"SQUARE"i/"TAN"i)
      ! olapFunc
      function   // if not one of the above, then assume a function is a string function
        

  left = &{return o.left_right_to_substr} 
    a:("LEFT"i) b:(_ '(' _) c:expression d:(_ "," _) e:expression f:(_ ')')  
    { return node('left',o.left_right_to_substr
      , [].concat("SUBSTR",b,c,d,"1,",e,f)
      , [].concat(a,b,c,d,e,f)
    )}
    // { return o.convert
    //   ? [].concat("SUBSTR",b,c,d,"1,",e,f)
    //   : [].concat(a,b,c,d,e,f)
    //   }

  right = &{return o.left_right_to_substr} 
    a:("RIGHT"i) b:(_ '(' _) c:expression d:(_ "," _) e:expression f:(_ ')')  
    { return o.convert
      ? [].concat("SUBSTR",b,c,d,"-",e,f)
      : [].concat(a,b,c,d,e,f)
    }

  stuff = &{return o.stuff_to_substr} 
    a:("STUFF"i) b:(_ '(' _)  c:expression d:(_ "," _) e:expression f:(_ "," _) g:expression h:(_ "," _) i:expression j:(_ ')')  
    { return o.convert
      ? [].concat("SUBSTR",b,c,d,"1,",e," - ",g,")||",i,"||","SUBSTR",b,c,d,e," + ",g,")")
      : [].concat(a,b,c,d,e,f,g,h,i,j)
    }

  concat = &{return o.concat_to_double_pipe} 
    a:("CONCAT"i) b:(_ '(' _) c:concatList? d:(_ ')')
    { return o.convert
      ? c
      : [].concat(a,b,c,d)
    } 
  concatList =  a:expression b:_ ',' c:_ d:concatList { return [].concat(a,b,'||',c,d) }
              / a:expression b:_ ',' c:_ d:expression { return [].concat(a,b,'||',c,d) }

  toTypeFunc =
    &{return o.toType_func_to_cast}
    "TO_"i a:basicTypeName b:_ c:'(' d:(_ expression _) e:')'
    { return o.convert && o.toType_func_to_cast
      ? [].concat("CAST",c,b,d," AS ",a,e) 
      : [].concat(a,b,c,d,e)
    }

  typeFunc = 
    &{return o.type_func_to_cast}
    a:basicTypeName b:_ c:'(' d:(_ expression _) e:')'
    { return o.convert
      ? [].concat("CAST",c,b,d," AS ",a,e) 
      : [].concat(a,b,c,d,e)
    }/* A */
  / &{return o.type_func_to_cast}
    a:basicTypeName b:_ c:'(' d:(_ expression _) e:',' f:(_ expression) g:(_ ',' _ expression)? h:(_ ')') 
    { return o.convert
      ? [].concat("CAST",c,b,d," AS ",a,'(',f,g,')',h) 
      : [].concat(a,b,c,d,e,f,g,h)
    }

  convert = 
    &{return o.convert_to_cast}
    a:("CONVERT"i) b:(_ '(' _) c:castType d:(_ ',' _) e:expression f:(_ ')')
    { if(o.analyze) el.funcs.push(a);
      return o.convert
      ? [].concat("CAST",b,e," AS ",c,f)
      : [].concat(a,b,c,d,e,f)
    } 
    / &{return o.convert_to_cast}  // translate CONVERTs with date/time style parameter
      a:("CONVERT"i) b:(_ '(' _) c:type d:(_ ',' _) e:expression f:(_ "," _) g:number h:(_ ')')
    { if(o.analyze) el.funcs.push(a);
      return o.convert
      ? [].concat('TO_CHAR(',e,",'"+o.convertDateTimeStyle(g)+"')") 
      : [].concat(a,b,c,d,f,g,h)
    }

  specialRegisters =
    a:"CURRENT"i b:__ c:("DATE"i/"TIMESTAMP"i/"TIME"i/"USER"i/"SCHEMA"i/"TIMEZONE"i)
    {return o.convert && o.add_underscore_to_currents
    ? [].concat(a,"_",c)
    : [].concat(a,b,c)
    } 

  dateAdd = &{return o.datetime_functions_to_arithmetic} 
    a:( "DATEADD"i / "TIMEADD"i _) b:('(' _) c:identifier d:(_ ',' _) e:expression f:(_ ',' _) g:expression h:(_ ')')
    {return o.convert
    ? [].concat(b,g,h,' + ',e,' ',c)
    : [].concat(a,b,c,d,e,f,g,h)
    }

  dateDiff = &{return o.datetime_functions_to_arithmetic} 
    a:( "DATEDIFF"i "_BIG"i? _) b:('(' _) c:( "DAY"i "S"i?) d:(_ ',' _) e:expression f:(_ ',' _) g:expression h:(_ ')')
    { return o.convert
      ? [].concat(x,g,h,[' - '],e) 
      : [].concat(a,b,c,d,e,f,g,h)
    }

  eomonth = &{return o.datetime_functions_to_arithmetic} 
    a:( "EOMONTH"i ) b:( _ "(" _ expression _ ) c:"," d:(_ expression) e:(_ ')') 
    { return o.convert
      ? [].concat('LAST_DAY',b," + ",d,' months',e)
      : [].concat(a,b,c,d,e)
    }
  / a:( "EOMONTH"i ) b:( _ "(" _ expression _ ')') 
    { return o.convert
      ? [].concat('LAST_DAY',b)
      : [].concat(a,b)
    }

  datetimeExtract =
    a:"EXTRACT"i b:_ c:'(' d:_ e:expression f:__ g:"FROM"i h:__ i:expression j:_ k:')'
    { if(o.analyze) {
        el.funcs.push([].concat(a,b,c,d,e,f,g,k))
        el.expressions.push([].concat(a,b,c,d,e,f,g,h,i,j,k))
      }
      return o.convert && o.extract_to_datetime_function
      ? [].concat(e,c,d,i,j,k)
      : [].concat(a,b,c,d,e,f,g,h,i,j,k)
    }

  datetimeFunctions =  &{return o.datetime_functions_to_extract}
    a:("YEAR"i/"MONTH"i/"DAY"i/"HOUR"i/"MINUTE"i/"SECOND"i/"EPOCH"i) b:_ c:'(' d:_ e:expression f:_ g:')' 
    { if(o.analyze) {
        el.funcs.push([].concat(a,b,c,g))
        el.expressions.push([].concat(a,b,c,d,e,f,g))
      }
      return o.convert
      ? [].concat('EXTRACT',b,c,a.toLowerCase(),' from ',d,e,f,g)
      : [].concat(a,b,c,d,e,f,g)
    }

  xmlAggToStringAgg = &{return o.xmlAggToStringAgg} 
  a:("RTRIM"i _ '(') b:( _ "XMLAGG"i _ "(" _ "XMLELEMENT"i _ "(" _ name _ "," ) c:(_ expression _)
  d:( _ "," _  ) e:("','") f:( _ ").EXTRACT"i _ "(" _ "'/" '/' "text()'" _ ")" _ ")"_ "," _ "','" _ ")")
    { return o.convert
      ? [].concat(o.stringAggFunction,'(',concatText(c),',',e,')')
      : [].concat(a,b,c,d,e,f)
    }

  // Refactor STUFF polyfill from SQL Server versions that don't have STRING_AGG LISTAGG 
  // https://stackoverflow.com/questions/31211506/how-stuff-and-for-xml-path-work-in-sql-server
  stuffXml = &{return o.stuff_xml_to_listagg} 
    a:("STUFF"i _ '(') b:( _ "(" _ "SELECT"i) __ c:("DISTINCT"i __)? d:("','" _ "+") e:(_ expression _)
    f:( _ from? _ where? _ groupBy? _ having? _ orderBy? _ limit? )
    g:("FOR"i __ "XML"i __  "PATH"i _ "(" _ "''" _ ")" _ ")" _ "," _ "1" _ "," _ "1" _ "," _ "''" _ ")")
  //    { return { t:[].concat(a,b,c,d,e,f,g), s:[].concat("(SELECT LISTAGG(",c,concatText(e)," ,',') ",f,")") } } // more generic replacemnt
    { return o.convert
      ? [].concat(o.stringAggFunction,'(',c,concatText(e)," ,',') ") 
      : [].concat(a,b,c,d,e,f,g)
    }

  // 88b 88  dP"Yb  88b 88     .dP"Y8  dP"Yb  88     
  // 88Yb88 dP   Yb 88Yb88     `Ybo." dP   Yb 88     
  // 88 Y88 Yb   dP 88 Y88     o.`Y8b Yb b dP 88  .o 
  // 88  Y8  YbodP  88  Y8     8bodP'  `"YoYo 88ood8 

  // embedded non-SQL syntax
  nonSql = //tribalSELdoubleCurlyBrackets
    nonSqlDoubleCurlyBrackets / nonSqlDoubleAngleBrackets
  nonSqlDoubleAngleBrackets = "<<" (! ">>" .)* ">>"   { return text() } // catch all eat of Tribal embeded code
  nonSqlDoubleCurlyBrackets = "{{" (! "}}" .)* "}}"   { return text() } // catch all eat of Tribal embeded code

  // tribalSELdoubleCurlyBrackets = "{{" tribalComment? "SEL:" tribalSELexpression ":" ( sqlStmt / fragment) "}}"
  // tribalComment = ws* "--" (! "--" .)* "--" ws*
  // tribalSELexpression = '(' _ tribalSELexpression _ ')' / ('"' [^"]* '"' / [^":]+ )*
  //fragment = (prefixOp /infixOp _ )? expression / '(' _ fragment _ ')' 


  //  88888    db    Yb    dP    db    
  //     88   dPYb    Yb  dP    dPYb   
  // o.  88  dP__Yb    YbdP    dP__Yb  
  // "bodP' dP""""Yb    YP    dP""""Yb 
  java =
      a:javaSQLStart b:sqlStmt c:javaSQLEnd
    / execSQL
    / include
    / javaIdentifier ('<' java? '>')?
    / javaLiteral 
    / '.' / ',' / '@' / ';'
    / java_op
    / '(' java* ')'
    / '{' java* '}'
    / '[' java* ']'  // this is actualy C/C++ array syntax
    / __

  // Embedded SQL such as Postgres ECPG — Embedded SQL in C - https://www.postgresql.org/docs/current/ecpg.html
  include = '#include' __ '<' name '>'
  execSQL = 
      "CONNECT"i __ "TO"i __ target (__ "AS"i __ name)? (__ "USER" __ name)?
    / "SET"i __ "CONNECTION"i __ target
    / "DISCONNECT"i __ ("ALL"i / target)
    / ("AT"i __ name __ )? sqlStmt
    / "BEGIN"i __ "DECLARE"i __ "SECTION"i
    / "END"i __ "DECLARE"i __ "SECTION"i
  target = 
      'tcp:postgresql:/' '/' name (':' number)? '/' name ('?'jdbcOptions)? //tcp:postgresql://hostname[:port][/dbname][?options]
    / 'unix:postgresql:/' '/localhost' (':' number)? '/' name ('?'jdbcOptions)? //unix:postgresql://localhost[:port][/dbname][?options]
    /  name ('@' name (':' number)?)? //dbname[@hostname][:port]
    / string  //an SQL string literal containing one of the above forms
    / "DEFAULT"i
    / name // a reference to a character variable containing one of the above forms (see examples)
  jdbcOptions = name '=' literal ('&' name '=' literal)*


  javaSQLStart = "statement.executeQuery"i _ '(' _ '"' _
  javaSQLEnd =  _ '"' _ ')' 

  javaIdentifier = javaLetter (javaLetter/[0-9])*
  javaLetter
      = [a-zA-Z$_] // these are the "java letters" below 0x7F
      / [\uD800-\uDBFF]

  java_op = 
    '=='  / '=' 
    / '>>>=' / '>>=' / '>=' / '>' 
    / '<<=' / '<=' / '<'
    / '!=' / '!'
    / '&&' / '&=' / '&' 
    / '||'  / '|=' / '|' 
    / '++' / '+=' / '+'
    / '--'  /  '-='  / '->' / '-' 
    / '*=' / '*'
    / '::'  / ':' 
    / '/='  / '/' 
    / '%=' / '%' 
    / '^=' 
    / '~' / '?'  / '^' 

  //// Java literals taken from https://github.com/antlr/grammars-v4/blob/master/java/java/JavaLexer.g4
  javaLiteral = javaDecimal / javaHex / javaOctal / javaBinary / javaFloat / javaHexFloat / javaBool / javaChar / javaString / javaText / javaNull
  javaDecimal =  ('0' / [1-9] (Digits? / '_'+ Digits)) [lL]?
  javaHex = '0' [xX] [0-9a-fA-F] ([0-9a-fA-F_]* [0-9a-fA-F])? [lL]?
  javaOctal =   '0' '_'* [0-7] ([0-7_]* [0-7])? [lL]?
  javaBinary = '0' [bB] [01] ([01_]* [01])? [lL]?
  javaFloat = (Digits '.' Digits? / '.' Digits) ExponentPart? [fFdD]?
              / Digits (ExponentPart [fFdD]? / [fFdD])
  javaHexFloat = '0' [xX] (HexDigits '.'? / HexDigits? '.' HexDigits) [pP] ('-'/'+')? Digits [fFdD]?
  javaBool =  'true' / 'false'
  javaChar =  "'" ([^'\\\r\n] / EscapeSequence) "'"
  javaString =  '"' ([^"\\\r\n] / EscapeSequence)* '"'
  javaText =  '"""' [ \t]* [\r\n] (. / EscapeSequence)* '"""'
  javaNull = 'null'
  ExponentPart = [eE] [+-]? Digits
  EscapeSequence =
        '\\' [btnfr"'\\]
      / '\\' ([0-3]? [0-7])? [0-7]
      / '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
  HexDigits = HexDigit ((HexDigit / '_')* HexDigit)?
  HexDigit =  [0-9a-fA-F]
  Digits = [0-9] ([0-9_]* [0-9])?

  // 88     88 888888 888888 88""Yb    db    88     .dP"Y8 
  // 88     88   88   88__   88__dP   dPYb   88     `Ybo." 
  // 88  .o 88   88   88""   88"Yb   dP__Yb  88  .o o.`Y8b 
  // 88ood8 88   88   888888 88  Yb dP""""Yb 88ood8 8bodP' 

  name = star / a:identifier b:(_ '.'+ _ name)*  // TODO move the SELECT * match to within a select list in main SELECT and add the alias to it..

  subPartorCast =
    _ '[' _ expression _ (':' _ expression _ )? ']' 
  / _ '::' _ type
  / _ (':'/'.') _ name

  identifier =
    variable / hostIdentifier / sqlIdentifier
      
  sqlIdentifier =  
    delimitedSqlIdentifier
  / &{return o.quote_common_reserved_identifiers} commonReservedIdentifier 
  / &{return o.quote_reserved_identifiers}        allReservedIdentifier
  / simpleName

  hostIdentifier = "?" 
    / a:(( [?@#$:] ( [0-9]+ / simpleName ) )) { if(o.analyze) el.params.push(text()); return {n:'hostIdentifier', t:text(), s:standardizeIdentifier(text(),'hi')} }

  simpleName = a:(([a-zA-Z_$#] / unicode ) ([a-zA-Z0-9_$#] / unicode )*) 
    { return o.convert ? standardizeIdentifier(text(),'si') : text() }

  variable = "@@" simpleName

  // TODO, pass this list in as an Javascript map. Will allow the set to be customised without rebuilding the parser
  //    List generated for Postgres with: SELECT STRING_AGG('"' || word || '"i','/' ORDER BY word desc) FROM pg_get_keywords() where not barelabel or catcode <> 'U'
  allReservedIdentifier = 
    ("year"i/"xmltable"i/"xmlserialize"i/"xmlroot"i/"xmlpi"i/"xmlparse"i/"xmlnamespaces"i/"xmlforest"i/"xmlexists"i/"xmlelement"i/"xmlconcat"i/"xmlattributes"i
    /"without"i/"within"i/"with"i/"window"i/"where"i/"when"i/"verbose"i/"varying"i/"varray"i/"variadic"i/"varchar"i/"values"i/"using"i/"user"i/"unique"i/"union"i
    /"true"i/"trim"i/"treat"i/"trailing"i/"to"i/"timestamp"i/"time"i/"then"i/"tablesample"i/"table"i/"sys_connect_by_path"i/"symmetric"i/"substring"i/"subpartition"i
    /"some"i/"smallint"i/"similar"i/"setof"i/"session_user"i/"select"i/"second"i/"row"i/"right"i/"returning"i/"references"i/"redaction"i/"real"i/"raw"i/"public"i/"prior"i
    /"primary"i/"precision"i/"pragma"i/"position"i/"placing"i/"partition"i/"package"i/"overriding"i/"overlay"i/"overlaps"i/"over"i/"out"i/"order"i/"or"i/"only"i/"on"i/"offset"i
    /"numeric"i/"nullif"i/"null"i/"notnull"i/"not"i/"normalize"i/"none"i/"nchar"i/"natural"i/"national"i/"multiset"i/"month"i/"minute"i/"minus"i/"maxtrans"i/"long"i/"localtimestamp"i
    /"localtime"i/"limit"i/"like"i/"left"i/"least"i/"leading"i/"lateral"i/"join"i/"isnull"i/"is"i/"into"i/"interval"i/"intersect"i/"integer"i/"int"i/"instantiable"i/"inout"i/"inner"i
    /"initrans"i/"initially"i/"in"i/"ilike"i/"hour"i/"having"i/"grouping_id"i/"grouping"i/"group"i/"greatest"i/"grant"i/"full"i/"from"i/"freeze"i/"foreign"i/"for"i/"float"i/"final"i
    /"filter"i/"fetch"i/"false"i/"extract"i/"exists"i/"exempt"i/"exception"i/"except"i/"end"i/"else"i/"do"i/"distinct"i/"desc"i/"deferrable"i/"default"i/"decimal"i/"dec"i/"day"i
    /"current_user"i/"current_timestamp"i/"current_time"i/"current_schema"i/"current_role"i/"current_catalog"i/"cross"i/"create"i/"constructor"i/"constraint"i/"connect_by_root"i
    /"connect"i/"concurrently"i/"column"i/"collation"i/"collate"i/"coalesce"i/"check"i/"character"i/"char"i/"cast"i/"case"i/"both"i/"boolean"i/"bit"i/"binary"i/"bigint"i/"between"i
    /"authorization"i/"asymmetric"i/"asc"i/"as"i/"array"i/"any"i/"and"i/"analyze"i/"analyse"i/"all"i)
    identifierEnd
    // List generated on Oracle with:  SELECT LISTAGG('"'||KEYWORD||'"i','/') WITHIN GROUP(ORDER BY LENGTH DESC, KEYWORD) FROM V$RESERVED_WORDS WHERE RESERVED = 'Y' AND LENGTH > 1
    { return o.convert
    ? '"'.concat(text().toUpperCase(),'"')
    : text()
    }

  commonReservedIdentifier = 
    ("INSERT"i/"NUMBER"i/"OPTION"i/"PUBLIC"i/"UPDATE"i/"VALUES"i/"CHECK"i/"GROUP"i/"INDEX"i/"ORDER"i/"PRIOR"i/"SHARE"i/"START"i/"TABLE"i/"CHAR"i/"DATE"i/"DESC"i/"ELSE"i/"FROM"i/"MODE"i/"SIZE"i/"TO"i)    
    identifierEnd
    { return o.convert
    ? '"'.concat(text().toUpperCase(),'"')
    : text()
    }

  delimitedSqlIdentifier =
    dqDelimitedSqlIdentifier  // dq = double quoted (identifier)
  / bqDelimitedSqlIdentifier  // bq = back quoted (identifier)
  / &{return o.sqDelimitedSqlIdentifier} sqDelimitedSqlIdentifier // Only e.g. SQL Server allows single quoted identifiers
  / &{return o.sbDelimitedSqlIdentifier} sbDelimitedSqlIdentifier // Some DBMSes (e.g. SQL Server) allow [] square bracket delimited identifiers

  dqDelimitedSqlIdentifier = '"' a:(([^"])/ '""')* '"'  { return o.convert ? standardizeIdentifier(a,'dq') : text() }
  bqDelimitedSqlIdentifier = '`' a:([^`]+) '`'          { return o.convert ? standardizeIdentifier(a,'bq') : text() }
  sqDelimitedSqlIdentifier = "'" a:(([^'])/ "''")* "'"  { return o.convert ? standardizeIdentifier(a,'sq') : text() }
  sbDelimitedSqlIdentifier = "[" a:([^\]])+ "]"         { return o.convert ? standardizeIdentifier(a,'sb') : text() }

  literal = string / float / number / boolean / date / timestamp / interval / hostIdentifier / array
  string = sqDelimitedString  / ddDelimitedString  / dqDelimitedString 

  sqDelimitedString  = "N"i? "'" a:(([^'])/ "''")* "'"    { return o.convert ? standardizeString(a,'sq') : text() }
  dqDelimitedString  = &{return o.dqDelimitedString } 
                        '"' a:([^"]*) '"'                { return o.convert ? standardizeString(a,'dq') : text() }
  ddDelimitedString  = dd a:(! dd .)* dd                 { return o.convert ? standardizeString(a,'dd') : text() }
  dd = '$' '$'  //avoid two consequative dollars as that is used to delimite Javascript code blocks in e.g. Snowflake, so messed up our deployment approach

  array = (_ "ARRAY"i )? _ '[' (_ expression (_ ',' _ expression)*)? _ ']' 

  number = ('-'/'+')?[0-9]+("."[0-9]*)? / "."[0-9]+          { return text() } 
  float =  ('-'/'+')?[0-9]+("."[0-9]*)?[Ee]('-'/'+')?[0-9]+  { return text() } 
  boolean = 'true'i / 'false'i

  date = isoDate / 'DATE'i __ isoDate
  timestamp = "TIMESTAMP"i __ string
  isoDate = "'"[0-9][0-9][0-9][0-9]"-"[0-2][0-9]"-"[0-2][0-9]"'" { return text() }

        comment = lineComment / blockComment
  lineComment  =r:( '--' EOL ) { return text() }
  blockComment = r:( '/*' ( (!'/*' !'*/' .) / blockComment )* ('*/'/EOF)  ) { return text() }

  interval = 'INTERVAL'i __ "'" _ number _ "'" (__ intervalUnit)? 
          / 'INTERVAL'i __ "'" _ number _ (__ intervalUnit)? (__ number __ intervalUnit)* _ "'"
          / 'INTERVAL'i __       number   (__ intervalUnit)? (__ number __ intervalUnit)*
  intervalUnit = intervalUnitName / intervalUnitAbbrev
  intervalUnitName = ( "microsecond"i / "millisecond"i / "second"i / "minute"i / "hour"i  
          / "day"i / "week"i / "month"i / "mon"i / "year"i / "decade"i / "century"i / "millennium"i ) "s"i?
  intervalUnitAbbrev = "ms"i / "y"i / "w"i / "d"i / "h"i / "s"i

  numberOrInterval = interval / number

  // 888888 Yb  dP 88""Yb 888888 .dP"Y8 
  //   88    YbdP  88__dP 88__   `Ybo." 
  //   88     8P   88"""  88""   o.`Y8b 
  //   88    dP    88     888888 8bodP' 
  types = type (_ ',' _ type)*

  castType = 
    sizedType
  / a:("CHARACTER"i / "CHAR"i/"NATIONAL" __ "CHARACTER"i /"NCHAR"i)                                   { return o.convert ? "CHAR(" +o.defaultCastStringLength+")" : text() }
  / a:("CHARACTER"i __ "VARYING"i / "VARCHAR"i/"NATIONAL" __ "CHARACTER" __ "VARYING"i /"NVARCHAR"i)  { return o.convert ? "VARCHAR("+o.defaultCastStringLength+")" : text() }
  / typeName

  sizedType = 
    typeName _ '(' _ 'MAX'i _ ')'
  / typeName _ '(' _ number _ ',' _ number _ ')'
  / typeName _ '(' _ number _ ')'
  / typedType

  type =   (sizedType ( __ withTZ)? / typeName) (arrayType)?
  arrayType =
    (__ "ARRAY"i {return o.toPostgres ? "":text()})? 
    _ '[' (_ expression (_ ',' _ expression)*)? _ ']' 

  typedType = typeName _ '<' _ type _ (',' _ type _)* '>'
  withTZ =  "WITH"i __ ("LOCAL"i __)? "TIME"i __ "ZONE"

  typeSizeUnits = 'BYTES'i / 'OCTECTS'i / 'CODEUNITS32'i / 'CODEUNITS16'i
  typeName = ( basicTypeName & literalEnd / name )
  basicTypeName =
    a:("SMALLINT"i / "INT16"i / "INT2"i)            { return o.standardizeTypeNames ? "SMALLINT": text() }
  / a:("BYTEINT"i / "TINYINT"i / "INT1"i)           { return o.standardizeTypeNames ? "BYTEINT" : text() }
  / a:("BIGINT"i / "INT64"i / "INT128"i / "INT8"i)  { return o.standardizeTypeNames ? "BIGINT"  : text() }
  / a:("INTEGER"i / "INT32"i / "INT4"i / "INT"i )   { return o.standardizeTypeNames ? "INTEGER" : text() }
  / a:("NUMERIC"i / "DECIMAL"i / "NUMBER"i)         { return o.standardizeTypeNames ? "DECIMAL" : text() }
  / a:("FLOAT"i / "REAL"i) 
  / a:("DOUBLE"i (__ "PRECISION")?)                 { return o.toPostgres ? "FLOAT8" : text()}
  / a:("VARCHAR2"i)                                                     { return o.standardizeTypeNames ? "VARCHAR": text() }
  / a:("CHARACTER" __ "VARYING"i / "VARCHAR"i / "TEXT"i / "STRING"i )   { return o.standardizeTypeNames ? "VARCHAR": text() }
  / a:("CHARACTER"i /"CHAR"i )                                          { return o.standardizeTypeNames ? "CHAR"   : text() }
  / a:("NATIONAL" __ "CHARACTER"i /"NCHAR"i)                            { return o.standardizeTypeNames ? "CHAR"   : text() }
  / a:("NATIONAL" __ "CHARACTER" __ "VARYING"i /"NVARCHAR"i)            { return o.standardizeTypeNames ? "VARCHAR": text() }
  / a:("BOOLEAN"i /"BOOL"i) 
  / a:("DATETIME"i/"DATE"i) 
  / a:("TIMESTAMP_NTZ"i) 
  / a:("TIMESTAMP_LTZ"i) 
  / a:("TIMESTAMP"i) 
  / a:("TIME"i / "TIMETZ"i) 
  / a:("INTERVAL"i) 
  / a:("TIMESPAN"i) 
  / a:("VARBINARY"i / "BINARY"i) 
  / a:("ST_GEOMETRY"i) 
  / a:("JSONB"i) 
  / a:("JSONPATH"i)
  / a:("JSON"i) 
  / a:("VARIANT"i/"OBJECT"i/"ARRAY"i)
  / a:("GEOGRAPHY"i/"GEOMETRY"i)

  literalEnd = ! [A-Z0-9a-z_]  // cater for typenames that start with explicit type names such as int_stack

  identifierEnd = & (__ / ','/ ')' / EOF) // used when matching reserved identifers. Look forward to check that the identifer has ended.
  skipUntilDelimiter = (literal / name / __)* stmtDelimiter { return o.convert? "" : text()}

  // Yb        dP 88  88 88 888888 888888 .dP"Y8 88""Yb    db     dP""b8 888888 
  //  Yb  db  dP  88  88 88   88   88__   `Ybo." 88__dP   dPYb   dP   `" 88__   
  //   YbdPYbdP   888888 88   88   88""   o.`Y8b 88"""   dP__Yb  Yb      88""   
  //    YP  YP    88  88 88   88   888888 8bodP' 88     dP""""Yb  YboodP 888888 


  _  "optional whitespace"  =  ( ws / comment / mssqlHint / collate )*  // TODO - Tricky here on reformatting as we want to keep any comments, but standardise the white space...
  __ "whitespace"           =s:( ws / comment / mssqlHint / collate )+  //{ return {n:'__', t:text(), f:' '}  }  // TODO, eat MS Sql hints
  ___ "whitespace or ("     = __ / & "("    // TODO -- add into main whitespace

  // Formatting whitespace captures
    _ws = a:(__ / & { return true }) { return o.format ? " " : a }    // Matches no whitespace where most sensible people would add it (e.g.e SELECT*FROM )
    _fl = a:_   { return o.format ? '\n'+indent()+'  ' : a }  // first line
  __fl = a:__  { return o.format ? '\n'+indent()+'  ' : a }  // first line
  ___fl = a:___ { return o.format ? '\n'+indent()+'  ' : a }  // first line
    _nl = a:_   { return o.format ? '\n'+indent()      : a }  // newline
  __nl = a:__  { return o.format ? '\n'+indent()      : a }  // newline
  ___nl = a:___ { return o.format ? '\n'+indent()      : a }  // newline
    _i = a:_   { return o.format ? '\n'+indent()+'  ' : a }  // indent
    __i = a:__  { return o.format ? '\n'+indent()+'  ' : a }  // indent

  ws = " "
    / [\t]    { return o.format ? '  ' : text() } 
    / [\n\r]  { return o.format ? '\n' : text() }  
  catchAll = [^ \t\n\r]+ { return text() }

  unicode = [\u00A0-\uFFFF]

      commaSep = a:(_ ',' _)   { return o.format ? ',' : a } 
  expCommaSep  = a:(_ ',' _)   { return o.format ? '\n'+indent() +', ' : a }  // for column expression lists that I format with newlines and leading commas

  // SQL Server hints can act as whitespace
  // https://docs.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver15
  mssqlHint ="(" ws? ("NOLOCK"i/"LOCK"i/"READUNCOMMITTED"i/"UPDLOCK"i/"REPEATABLEREAD"i/"SERIALIZABLE"i/"READCOMMITTED"i/"TABLOCK"i/"TABLOCKX"i/"PAGLOCK"i/"ROWLOCK"i/"NOWAIT"i/"READPAST"i/"XLOCK"i/"SNAPSHOT"i/"NOEXPAND"i) ws? ")" 
              { return o.convert && ! o.toMSSQL ? " " : text() }
  collate = "COLLATE" __ (sqlIdentifier / string / "CASE_SENSITIVE"i / "CASE_INSENSITIVE"i )
  EOL = [^\n\r]* ([\n\r]/EOF)
  EOF = !.
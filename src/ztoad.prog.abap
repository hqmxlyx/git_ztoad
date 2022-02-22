*&---------------------------------------------------------------------*
*& Program : ZTOAD
*& Author  : S. Hermann
*& Date    : 31.12.2017
*& Version : 4.0.2
*& Required: Table ZTOAD
*&---------------------------------------------------------------------*
*& This program allow you to execute query directly on the server
*& 1/ Write your query in the editor window (ABAP SQL)
*& 2/ View the result in ALV window (in case of SELECT query)
*&
*3 Features :
*& The top center pane allow you to write your query in ABAP SQL format.
*= Query can be complex with JOIN, UNION and subqueries. You can write
*= query on several lines. You could also add spaces.
*= To add comment, start the line by * or prefix your comment by "
*&
*& You could write several queries in the query editor, separated by
*= dot ".". To execute one of them, highlight all the wanted query,
*= or just put the cursor anywhere inside the wanted query.
*= By default, the last query is executed.
*&
*& In case of error, you can display generated code to help you to
*= correct your query (only if you have S_DEVELOP access)
*&
*& F1 Help is managed to help you on ABAP SQL Syntax
*& Code completion is also available :
*& - TAB to autocomplete with tooltip word
*& - CTRL + ESPACE to display list of available words
*& Be carefull to not use with INSERT statement (see below)
*&
*& The top left pane allow you to store your query :
*& - You could save your query to reuse it later
*& - You could share your query : define users, usergroup, all
*& - You could export query into file to reuse it on another server
*&
*& The top right pane display ddic object that is currently used to help
*= you to write the proper query
*& Synergy with ZSPRO program : display tables defined in ZSPRO in the
*= ddic tree
*& Tips : You can search a table in the tree using header clic
*&
*3 Managed queries
*& SELECT, INSERT, UPDATE, DELETE, Any native SQL command
*&
*3 About New SQL Query Syntax
*& You could use new syntax (if your SAP system manage it)
*& ZTOAD autmatically detect if you are using new sytax when:
*& - You separated your selected fields with comma
*& - You prefixed your variable with @ in the INTO TABLE statement
*&
*3 Select Clause managed
*& SELECT [DISTINCT / SINGLE] select clause
*& FROM from clause
*& [UP TO x ROWS]
*& [WHERE cond1]
*& [GROUP BY fields1]
*& [HAVING cond2]
*& [ORDER BY fields2]
*& [UNION SELECT...]
*&
*& UP TO (Default max rows) ROWS added at end of query if omitted
*& You could force select without limits by adding UP TO 0 ROWS
*&
*& COUNT, AVG, MAX, MIN, SUM are managed
*& DO NOT FORGET SPACE in ( ) of aggregat
*&
*3 Insert special syntax
*& In ABAP, insert query is always used with given structure
*& In this SQL editor, you have 2 ways to do an INSERT :
*& - By passing each value, 1 by 1
*E INSERT SEOCLASSTX VALUES ( 'ZZMACLASS', ' ', 'Test claSS' )
*&
*& - By passing value of used fields only
*E INSERT SEOCLASSTX SET CLSNAME = 'ZZMACLASS' DESCRIPT = 'TeSt class'
*&
*3 Native SQL special syntax
*& To execute a native SQL command, please add the prefix NATIVE
*& before your query
*& NATIVE CREATE INDEX 'TESTINDEX' ON T001 (MANDT, WAERS, BUKRS)
*& NATIVE DROP INDEX 'TESTINDEX'
*&
*3 Sample of query :
*&
*E SELECT SINGLE * FROM VBAP WHERE VBELN = '00412345678'
*&
*E SELECT COUNT( * ) SUBC MAX( PROG ) FROM TRDIR GROUP BY SUBC
*&
*E SELECT VBAK~* from VBAK UP TO 3 ROWS ORDER BY VKORG.
*&
*E SELECT T1~VBELN T2~POSNR FROM VBAk AS T1
*E        JOIN VBAP AS T2 ON T1~VBELN = T2~VBELN
*&
*E INSERT SEOCLASSTX VALUES ( 'ZZMACLASS', ' ', 'Test claSS' )
*&
*E INSERT SEOCLASSTX SET CLSNAME = 'ZZMACLASS' DESCRIPT = 'TeSt class'
*&
*E UPDATE SEOCLASSTX SET DESCRIPT = 'txt' WHERE CLSNAME = 'ZZMACLASS'
*&
*E DELETE SEOCLASSTX WHERE CLSNAME = 'ZZMACLASS'
*&
*& Please send comment & improvements to http://quelquepart.biz
*&---------------------------------------------------------------------*
*& History :
*& 2017.12.31 v4.0.2:Fix dump in case of multiple aggregations
*&                       Thanks to Sabrina Villa for the fix
*& 2017.04.01 v4.0.1:Fix new Tab dump
*& 2016.12.17 v4.0  :Add Tab management. You can have up to 30 tabs
*&                   Fix Status corruption
*&                   Add Import/Export function for saved queries
*&                   Mod Code cleaning
*& 2016.09.10 v3.6  :Add New syntax management of "case"
*& 2016.07.06 v3.5.1:Fix Auth issue
*&                   Fix Dump on select with no empty selection part
*& 2016.03.28 v3.5  :Add Value Help on DDIC field. Select a value to
*&                       paste in editor
*&                   Add Button Execute into file to download results
*&                       instead of display it in ALV
*&                   Mod Use class CL_RSAWB_SPLITTER_FOR_TOOLBAR for
*&                       creation of DDIC toolbar
*&                   Add Refresh the DDIC tree when executing a query
*&                       even if error found
*& Thanks to Patrick Prime Reinoso for the following changes :
*&                   Fix Remove confirmation popup on display code for
*&                       no select statement
*&                   Add Option to display technical name in ALV
*&                   Mod Move option button to main toolbar
*&                   Mod Rename subroutines (code cleaning)
*&                   Mod Allow save on exit popup
*&                   Add New query button
*&                   Mod New query template changed
*& 2015.11.07 v3.4.3:Fix dump if cursor on first position
*&                   Fix prevent dump on too many sql run
*& 2015.11.07 v3.4.2:Fix cancel of save query popup
*&                   Fix Allow usage of " and . inside ''
*& 2015.11.01 v3.4.1:Fix issue with delete all history context menu
*& 2015.09.19 v3.4  :Add Code completion on SQL editor
*&                   Thanks to Benjamin Krencker for his code
*&                   Add Remove useless APPENDING TABLE statement in qry
*& 2015.09.13 v3.3  :Add New Options panel to save user preferences
*&                   Add Delete all history entries context menu
*&                   Add option to add linebreak after paste field from
*&                       ddic tree
*&                   Add Count column in alv grid display
*&                   Thanks again to Shai Sinai for his suggestions
*& 2015.09.06 v3.2.1:Mod Default limit to 100 rows is now optional
*& 2015.08.30 v3.2  :Add Manage new SQL Syntax introduced by NW7.40 SP5
*&                   Add Remove useless INTO TABLE statement in query
*&                   Add All NATIVE Sql commands
*&                   Mod Auth object use now the sap standard way
*&                   Fix Dump in case of up to xx rows in unioned query
*&                   Fix Dump at activation if ZSPRO does not exist
*&                   Fix Compatibility issues with older sap system
*& 2015.08.05 v3.1  :Add Manage drag&drop from DDIC tree to SQL Editor
*&                   Mod Double clic on field in DDIC tree paste field
*&                       in editor instead of filling clipboard
*&                   Thanks to Shai Sinai for his suggestions
*& 2015.06.13 v3.0  :Add INSERT, UPDATE, DELETE command
*&                   Add Authorization management
*&                   Add History tree display first query line if it
*&                       is a comment line
*&                   Mod Code cleaning
*& 2015.03.05 v2.1.1:Mod grid size is no more changed before display
*&                       query result
*& 2015.01.11 v2.1  :Add UNION instruction managed to merge 2 queries
*&                   Mod Do not refresh result grid for count(*)
*&                   Mod Back close the grid instead of leave program if
*&                       result grid is displayed
*&                   Add Display program header as default help
*&                   Add Run highlighted query
*&                   Mod Documentation rewritten
*& 2014.10.23 v2.0.2:Add Display number of entries found
*&                   Add Confirmation before exit for unsaved queries
*& 2014.10.19 v2.0.1:Fix bug on search ddic function
*& 2014.08.03 v2.0 : Completely rewritten version
*&                   - Save and share queries with colaborators
*&                   - Queries are now saved in database
*&                   - Display tables (+ fields) of the where clause
*&                   - Display ZSPRO entries in ddic tree
*&                   - Allow direct change in query after execution
*&                   - Count( * ) allowed
*&                   - Can display generated code
*&                   - Display query execution time
*&                   - Allow write of several queries (but 1 executed)
*& 2013.12.03 v1.3 : Allow case sensitive constant in where clause
*& 2012.08.30 v1.2 : Rewrite data definition to avoid dump on too long
*&                   fieldname
*& 2012.04.01 v1.1 : Updated to work also on BW system
*& 2009.10.26 v1.0 : Initial release
*&---------------------------------------------------------------------*

REPORT ZTOAD.
TYPE-POOLS ABAP.
INCLUDE ZINC_ZTOAD_TOP.
*######################################################################*
*
*                        CUSTOMIZATION SECTION
*
*######################################################################*
DATA : BEGIN OF S_CUSTOMIZE,                                "#EC NEEDED
* Default number of lines to return for SELECT if no "up to xxx rows"
* defined in the query.
* Set to 0 if you dont want default limit.
         DEFAULT_ROWS    TYPE I VALUE 100,

* When you dblclic on a field in the ddic tree, field is pasted to
* editor at the cursor position
* You could choose to add a linebreak after the field pasted
         PASTE_BREAK(1)  TYPE C VALUE SPACE, "abap_true to break

* In ALV grid result, display technical name instead of column label
         TECHNAME(1)     TYPE C VALUE SPACE, "abap_true for technical

* You could define your authorization object to restrict
* function usage by user
* If you dont define auth object, all users will have same access as
* defined bellow
* The auth object have 2 fields TABLE and ACTVT
* ACTVT can take 5 values that you could define here. By default :
* 01 for INSERT command
* 02 for UPDATE command
* 03 for SELECT command
* 06 for DELETE command
* 16 for EXECUTE NATIVE SQL command
* TABLE contain allowed table name pattern
* '*' to allow all table, 'Z*' to allow all specific tables...
         AUTH_OBJECT(20) TYPE C VALUE '', "'ZTOAD_AUTH',
         ACTVT_SELECT    TYPE TACTT-ACTVT VALUE '03',
         ACTVT_INSERT    TYPE TACTT-ACTVT VALUE '01',
         ACTVT_UPDATE    TYPE TACTT-ACTVT VALUE '02',
         ACTVT_DELETE    TYPE TACTT-ACTVT VALUE '06',
         ACTVT_NATIVE    TYPE TACTT-ACTVT VALUE '16',

* Bellow is default AUTH used if no auth_object is defined
* Allow SELECT query on SAP table (restricted by given pattern)
         AUTH_SELECT     TYPE STRING VALUE '*',
* Allow INSERT query on SAP table (restricted by given pattern)
         AUTH_INSERT     TYPE STRING VALUE SPACE, "'*',
* Allow UPDATE query on SAP table (restricted by given pattern)
         AUTH_UPDATE     TYPE STRING VALUE SPACE, "'*',
* Allow DELETE query on SAP table (restricted by given pattern)
         AUTH_DELETE     TYPE STRING VALUE SPACE, "'*',
* Allow any native sql command (set value to space to disable)
         AUTH_NATIVE(1)  TYPE C VALUE SPACE, "abap_true,

       END OF S_CUSTOMIZE.


*######################################################################*
*
*                             DATA SECTION
*
*######################################################################*
* Objects
CLASS LCL_APPLICATION DEFINITION DEFERRED.

* Screen objects
DATA : O_HANDLE_EVENT         TYPE REF TO LCL_APPLICATION,
       O_CONTAINER            TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       O_SPLITTER             TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
       O_SPLITTER_TOP         TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
       O_SPLITTER_TOP_RIGHT   TYPE REF TO CL_RSAWB_SPLITTER_FOR_TOOLBAR,
       O_CONTAINER_TOP        TYPE REF TO CL_GUI_CONTAINER,
       O_CONTAINER_TOP_RIGHT  TYPE REF TO CL_GUI_CONTAINER,
       O_CONTAINER_REPOSITORY TYPE REF TO CL_GUI_CONTAINER,
       O_CONTAINER_OPTIONS    TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       O_CONTAINER_QUERY      TYPE REF TO CL_GUI_CONTAINER,
       O_CONTAINER_DDIC       TYPE REF TO CL_GUI_CONTAINER,
       O_CONTAINER_RESULT     TYPE REF TO CL_GUI_CONTAINER,

* Tabs objects (editor, ddic, alv)
       BEGIN OF S_TAB_ACTIVE,
         O_TEXTEDIT   TYPE REF TO CL_GUI_ABAPEDIT,
         O_TREE_DDIC  TYPE REF TO CL_GUI_COLUMN_TREE,
         T_NODE_DDIC  TYPE TREEV_NTAB,
         T_ITEM_DDIC  TYPE TABLE OF MTREEITM,
         O_ALV_RESULT TYPE REF TO CL_GUI_ALV_GRID,
         ROW_HEIGHT   TYPE I,
       END OF S_TAB_ACTIVE,
       T_TABS            LIKE TABLE OF S_TAB_ACTIVE,

* Repository data
       O_TREE_REPOSITORY TYPE REF TO CL_GUI_SIMPLE_TREE,
       BEGIN OF S_NODE_REPOSITORY.
         INCLUDE TYPE TREEV_NODE. "mtreesnode.
         DATA :  TEXT(100) TYPE C,
         EDIT(1)   TYPE C,
         QUERYID   TYPE ZTOAD-QUERYID,
       END OF S_NODE_REPOSITORY,
       T_NODE_REPOSITORY      LIKE TABLE OF S_NODE_REPOSITORY,

* DDIC data
       W_DRAGDROP_HANDLE_TREE TYPE I,
* DDIC toolbar
       O_TOOLBAR              TYPE REF TO CL_GUI_TOOLBAR,
* Option panel
       O_OPTIONS              TYPE REF TO CL_WDY_WB_PROPERTY_BOX,
* ZSPRO data
       T_NODE_ZSPRO           LIKE S_TAB_ACTIVE-T_NODE_DDIC,
       T_ITEM_ZSPRO           LIKE S_TAB_ACTIVE-T_ITEM_DDIC,

* Save option
       BEGIN OF S_OPTIONS,
         NAME          TYPE ZTOAD-TEXT,
         VISIBILITY    TYPE ZTOAD-VISIBILITY,
         VISIBILITYGRP TYPE USR02-CLASS,
       END OF S_OPTIONS,

* Keep last loaded id
       W_LAST_LOADED_QUERY TYPE ZTOAD-QUERYID,

* Count number of runs
       W_RUN               TYPE I.

DATA : W_OKCODE LIKE SY-UCOMM,
       BEGIN OF S_TAB,
         TITLE1  TYPE STRING VALUE 'Tab 1',                 "#EC NOTEXT
         TITLE2  TYPE STRING VALUE 'Tab 2',                 "#EC NOTEXT
         TITLE3  TYPE STRING VALUE 'Tab 3',                 "#EC NOTEXT
         TITLE4  TYPE STRING VALUE 'Tab 4',                 "#EC NOTEXT
         TITLE5  TYPE STRING VALUE 'Tab 5',                 "#EC NOTEXT
         TITLE6  TYPE STRING VALUE 'Tab 6',                 "#EC NOTEXT
         TITLE7  TYPE STRING VALUE 'Tab 7',                 "#EC NOTEXT
         TITLE8  TYPE STRING VALUE 'Tab 8',                 "#EC NOTEXT
         TITLE9  TYPE STRING VALUE 'Tab 9',                 "#EC NOTEXT
         TITLE10 TYPE STRING VALUE 'Tab 10',                "#EC NOTEXT
         TITLE11 TYPE STRING VALUE 'Tab 11',                "#EC NOTEXT
         TITLE12 TYPE STRING VALUE 'Tab 12',                "#EC NOTEXT
         TITLE13 TYPE STRING VALUE 'Tab 13',                "#EC NOTEXT
         TITLE14 TYPE STRING VALUE 'Tab 14',                "#EC NOTEXT
         TITLE15 TYPE STRING VALUE 'Tab 15',                "#EC NOTEXT
         TITLE16 TYPE STRING VALUE 'Tab 16',                "#EC NOTEXT
         TITLE17 TYPE STRING VALUE 'Tab 17',                "#EC NOTEXT
         TITLE18 TYPE STRING VALUE 'Tab 18',                "#EC NOTEXT
         TITLE19 TYPE STRING VALUE 'Tab 19',                "#EC NOTEXT
         TITLE20 TYPE STRING VALUE 'Tab 20',                "#EC NOTEXT
         TITLE21 TYPE STRING VALUE 'Tab 21',                "#EC NOTEXT
         TITLE22 TYPE STRING VALUE 'Tab 22',                "#EC NOTEXT
         TITLE23 TYPE STRING VALUE 'Tab 23',                "#EC NOTEXT
         TITLE24 TYPE STRING VALUE 'Tab 24',                "#EC NOTEXT
         TITLE25 TYPE STRING VALUE 'Tab 25',                "#EC NOTEXT
         TITLE26 TYPE STRING VALUE 'Tab 26',                "#EC NOTEXT
         TITLE27 TYPE STRING VALUE 'Tab 27',                "#EC NOTEXT
         TITLE28 TYPE STRING VALUE 'Tab 28',                "#EC NOTEXT
         TITLE29 TYPE STRING VALUE 'Tab 29',                "#EC NOTEXT
         TITLE30 TYPE STRING VALUE 'Tab 30',                "#EC NOTEXT
       END OF S_TAB.
CONTROLS W_TABSTRIP TYPE TABSTRIP.

* Global types



* Constants
CONSTANTS : C_DDIC_COL1            TYPE MTREEITM-ITEM_NAME
                        VALUE 'col1',                       "#EC NOTEXT
            C_DDIC_COL2            TYPE MTREEITM-ITEM_NAME
                        VALUE 'col2',                       "#EC NOTEXT
            C_VISIBILITY_ALL       TYPE ZTOAD-VISIBILITY VALUE '2',
            C_VISIBILITY_SHARED    TYPE ZTOAD-VISIBILITY VALUE '1',
            C_VISIBILITY_MY        TYPE ZTOAD-VISIBILITY VALUE '0',
            C_NODEKEY_REPO_MY      TYPE MTREESNODE-NODE_KEY VALUE 'MY',
            C_NODEKEY_REPO_SHARED  TYPE MTREESNODE-NODE_KEY
                                  VALUE 'SHARED',
            C_NODEKEY_REPO_HISTORY TYPE MTREESNODE-NODE_KEY
                                   VALUE 'HISTO',
            C_LINE_MAX             TYPE I VALUE 255,
            C_MSG_SUCCESS          TYPE C VALUE 'S',
            C_MSG_ERROR            TYPE C VALUE 'E',
            C_VERS_ACTIVE          TYPE AS4LOCAL VALUE 'A',
            C_DDIC_DTELM           TYPE COMPTYPE VALUE 'E',
            C_NATIVE_COMMAND       TYPE STRING VALUE 'NATIVE',
            C_QUERY_MAX_EXEC       TYPE I VALUE 36,

            C_XMLNODE_ROOT         TYPE STRING VALUE 'root', "#EC NOTEXT
            C_XMLNODE_FILE         TYPE STRING VALUE 'query', "#EC NOTEXT
            C_XMLATTR_VISIBILITY   TYPE STRING VALUE 'visibility', "#EC NOTEXT
            C_XMLATTR_TEXT         TYPE STRING VALUE 'description'. "#EC NOTEXT



*######################################################################*
*
*                             CLASS SECTION
*
*######################################################################*

*----------------------------------------------------------------------*
*       CLASS lcl_drag_object DEFINITION
*----------------------------------------------------------------------*
*       Class to store object on drag & drop from DDIC to sql editor
*----------------------------------------------------------------------*
CLASS LCL_DRAG_OBJECT DEFINITION FINAL.
  PUBLIC SECTION.
    DATA FIELD TYPE STRING.
ENDCLASS."lcl_drag_object DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_application DEFINITION
*----------------------------------------------------------------------*
*       Class to handle application events
*----------------------------------------------------------------------*
CLASS LCL_APPLICATION DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS :
* Handle F1 call on ABAP editor
      HND_EDITOR_F1
        FOR EVENT F1 OF CL_GUI_ABAPEDIT,
* Handle Node double clic on ddic tree
      HND_DDIC_ITEM_DBLCLICK
                  FOR EVENT ITEM_DOUBLE_CLICK OF CL_GUI_COLUMN_TREE
        IMPORTING NODE_KEY,
* Handle context menu display on repository tree
      HND_REPO_CONTEXT_MENU
      FOR EVENT NODE_CONTEXT_MENU_REQUEST
                  OF CL_GUI_SIMPLE_TREE
        IMPORTING MENU,
* Handle context menu clic on repository tree
      HND_REPO_CONTEXT_MENU_SEL
      FOR EVENT NODE_CONTEXT_MENU_SELECT
                  OF CL_GUI_SIMPLE_TREE
        IMPORTING FCODE,
* Handle Node double clic on repository tree
      HND_REPO_DBLCLICK
                  FOR EVENT NODE_DOUBLE_CLICK OF CL_GUI_SIMPLE_TREE
        IMPORTING NODE_KEY,
* Handle toolbar display on ALV result
      HND_RESULT_TOOLBAR
                  FOR EVENT TOOLBAR OF CL_GUI_ALV_GRID
        IMPORTING E_OBJECT,
* Handle toolbar clic on ALV result
      HND_RESULT_USER_COMMAND
                  FOR EVENT USER_COMMAND OF CL_GUI_ALV_GRID
        IMPORTING E_UCOMM,
* Handle DDIC tree drag
      HND_DDIC_DRAG
                  FOR EVENT ON_DRAG OF CL_GUI_COLUMN_TREE
        IMPORTING NODE_KEY DRAG_DROP_OBJECT,
* Handle editor drop
      HND_EDITOR_DROP
                  FOR EVENT ON_DROP OF CL_GUI_ABAPEDIT
        IMPORTING LINE POS DRAGDROP_OBJECT,
* Handle ddic toolbar clic
      HND_DDIC_TOOLBAR_CLIC
                  FOR EVENT FUNCTION_SELECTED OF CL_GUI_TOOLBAR
        IMPORTING FCODE.
ENDCLASS.                    "lcl_application DEFINITION

*----------------------------------------------------------------------*
*       CLASS LCL_APPLICATION IMPLEMENTATION
*----------------------------------------------------------------------*
*       Class to handle application events                             *
*----------------------------------------------------------------------*
CLASS LCL_APPLICATION IMPLEMENTATION.
*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_repo_context_menu
*&---------------------------------------------------------------------*
*       Handle context menu display on repository tree
*----------------------------------------------------------------------*
  METHOD HND_REPO_CONTEXT_MENU.
    DATA L_NODE_KEY TYPE TV_NODEKEY.

    CALL METHOD O_TREE_REPOSITORY->GET_SELECTED_NODE
      IMPORTING
        NODE_KEY = L_NODE_KEY.
* For History node, add a "delete all" entry
* Only if there is at least 1 history entry
    IF L_NODE_KEY = 'HISTO'.
      READ TABLE T_NODE_REPOSITORY TRANSPORTING NO FIELDS
        WITH KEY RELATKEY = 'HISTO'.
      IF SY-SUBRC = 0.
        CALL METHOD MENU->ADD_FUNCTION
          EXPORTING
            TEXT  = 'Delete All'(m36)
            ICON  = '@02@'
            FCODE = 'DELETE_HIST'.
      ENDIF.
      RETURN.
    ENDIF.

* Add Delete option only for own queries
    READ TABLE T_NODE_REPOSITORY INTO S_NODE_REPOSITORY
               WITH KEY NODE_KEY = L_NODE_KEY.
    IF SY-SUBRC NE 0 OR S_NODE_REPOSITORY-EDIT = SPACE.
      RETURN.
    ENDIF.

    CALL METHOD MENU->ADD_FUNCTION
      EXPORTING
        TEXT  = 'Delete'(m01)
        ICON  = '@02@'
        FCODE = 'DELETE_QUERY'.
  ENDMETHOD.                    "hnd_repo_context_menu

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_repo_context_menu_sel
*&---------------------------------------------------------------------*
*       Handle context menu clic on repository tree
*----------------------------------------------------------------------*
  METHOD HND_REPO_CONTEXT_MENU_SEL.
    DATA : L_NODE_KEY TYPE TV_NODEKEY,
           L_SUBRC    TYPE I,
           LS_HISTO   LIKE S_NODE_REPOSITORY,
           LW_QUERYID LIKE LS_HISTO-QUERYID.
* Delete stored query
    CASE FCODE.
      WHEN 'DELETE_QUERY'.
        CALL METHOD O_TREE_REPOSITORY->GET_SELECTED_NODE
          IMPORTING
            NODE_KEY = L_NODE_KEY.
        PERFORM REPO_DELETE_HISTORY USING L_NODE_KEY
                                    CHANGING L_SUBRC.
        IF L_SUBRC = 0.
          MESSAGE 'Query deleted'(m02) TYPE C_MSG_SUCCESS.
        ELSE.
          MESSAGE 'Error when deleting the query'(m03)
                  TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
          RETURN.
        ENDIF.

      WHEN 'DELETE_HIST'.
        CONCATENATE SY-UNAME '+++' INTO LW_QUERYID.
        LOOP AT T_NODE_REPOSITORY INTO LS_HISTO
                WHERE QUERYID CP LW_QUERYID.
          PERFORM REPO_DELETE_HISTORY USING LS_HISTO-NODE_KEY
                                      CHANGING L_SUBRC.
          IF L_SUBRC NE 0.
            MESSAGE 'Error when deleting the query'(m03)
                    TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
            RETURN.
          ENDIF.
        ENDLOOP.
        MESSAGE 'All history entries deleted'(m37) TYPE C_MSG_SUCCESS.
    ENDCASE.
  ENDMETHOD.                    "hnd_repo_context_menu_sel

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_editor_f1
*&---------------------------------------------------------------------*
*       Handle F1 call on ABAP editor
*----------------------------------------------------------------------*
  METHOD HND_EDITOR_F1.
    DATA : LW_CURSOR_LINE_FROM TYPE I,
           LW_CURSOR_LINE_TO   TYPE I,
           LW_CURSOR_POS_FROM  TYPE I,
           LW_CURSOR_POS_TO    TYPE I,
           LW_OFFSET           TYPE I,
           LW_LENGTH           TYPE I,
           LT_QUERY            TYPE SOLI_TAB,
           LS_QUERY            LIKE LINE OF LT_QUERY,
           LW_SEL              TYPE STRING.

* Find active query
    CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_SELECTION_POS
      IMPORTING
        FROM_LINE = LW_CURSOR_LINE_FROM
        FROM_POS  = LW_CURSOR_POS_FROM
        TO_LINE   = LW_CURSOR_LINE_TO
        TO_POS    = LW_CURSOR_POS_TO.

* If nothing selected, no help to display
    IF LW_CURSOR_LINE_FROM = LW_CURSOR_LINE_TO
    AND LW_CURSOR_POS_TO = LW_CURSOR_POS_FROM.
      RETURN.
    ENDIF.

* Get content of abap edit box
    CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXT
      IMPORTING
        TABLE  = LT_QUERY[]
      EXCEPTIONS
        OTHERS = 1.


    READ TABLE LT_QUERY INTO LS_QUERY INDEX LW_CURSOR_LINE_FROM.
    IF LW_CURSOR_LINE_FROM = LW_CURSOR_LINE_TO.
      LW_LENGTH = LW_CURSOR_POS_TO - LW_CURSOR_POS_FROM.
      LW_OFFSET = LW_CURSOR_POS_FROM - 1.
      LW_SEL = LS_QUERY+LW_OFFSET(LW_LENGTH).
    ELSE.
      LW_OFFSET = LW_CURSOR_POS_FROM - 1.
      LW_SEL = LS_QUERY+LW_OFFSET.
    ENDIF.
    CALL FUNCTION 'ABAP_DOCU_START'
      EXPORTING
        WORD = LW_SEL.
  ENDMETHOD.                    "hnd_editor_f1

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_ddic_item_dblclick
*&---------------------------------------------------------------------*
*       Handle Node double clic on ddic tree
*----------------------------------------------------------------------*
  METHOD HND_DDIC_ITEM_DBLCLICK.
    DATA : LS_NODE       LIKE LINE OF S_TAB_ACTIVE-T_NODE_DDIC,
           LW_LINE_START TYPE I,
           LW_POS_START  TYPE I,
           LW_LINE_END   TYPE I,
           LW_POS_END    TYPE I,
           LW_DATA       TYPE STRING.

* Check clicked node is valid
    READ TABLE S_TAB_ACTIVE-T_NODE_DDIC INTO LS_NODE
               WITH KEY NODE_KEY = NODE_KEY.
    IF SY-SUBRC NE 0 OR LS_NODE-ISFOLDER = ABAP_TRUE.
      RETURN.
    ENDIF.

* Get text for the node selected
    PERFORM DDIC_GET_FIELD_FROM_NODE USING NODE_KEY LS_NODE-RELATKEY
                                     CHANGING LW_DATA.

* Get current cursor position/selection in editor
    CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_SELECTION_POS
      IMPORTING
        FROM_LINE = LW_LINE_START
        FROM_POS  = LW_POS_START
        TO_LINE   = LW_LINE_END
        TO_POS    = LW_POS_END
      EXCEPTIONS
        OTHERS    = 4.
    IF SY-SUBRC NE 0.
      MESSAGE 'Cannot get cursor position'(m35) TYPE C_MSG_ERROR.
    ENDIF.

*   If text is selected/highlighted, delete it
    IF LW_LINE_START NE LW_LINE_END
    OR LW_POS_START NE LW_POS_END.
      CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->DELETE_TEXT
        EXPORTING
          FROM_LINE = LW_LINE_START
          FROM_POS  = LW_POS_START
          TO_LINE   = LW_LINE_END
          TO_POS    = LW_POS_END.
    ENDIF.

    PERFORM EDITOR_PASTE USING LW_DATA LW_LINE_START LW_POS_START.
  ENDMETHOD.                    "hnd_ddic_item_dblclick

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_repo_dblclick
*&---------------------------------------------------------------------*
*       Handle Node double clic on repository tree
*----------------------------------------------------------------------*
  METHOD HND_REPO_DBLCLICK.
    DATA LT_QUERY TYPE TABLE OF STRING.
    READ TABLE T_NODE_REPOSITORY INTO S_NODE_REPOSITORY
               WITH KEY NODE_KEY = NODE_KEY.
    IF SY-SUBRC = 0 AND NOT S_NODE_REPOSITORY-RELATKEY IS INITIAL.
      PERFORM QUERY_LOAD USING S_NODE_REPOSITORY-QUERYID
                         CHANGING LT_QUERY.

      CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_TEXT
        EXPORTING
          TABLE  = LT_QUERY
        EXCEPTIONS
          OTHERS = 0.

      PERFORM DDIC_REFRESH_TREE.
    ENDIF.
  ENDMETHOD. "hnd_repo_dblclick

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_result_toolbar
*&---------------------------------------------------------------------*
*       Handle grid toolbar to add specific button
*----------------------------------------------------------------------*
  METHOD HND_RESULT_TOOLBAR.
    DATA: LS_TOOLBAR  TYPE STB_BUTTON.

* Add Separator
    CLEAR LS_TOOLBAR.
    LS_TOOLBAR-FUNCTION = '&&SEP99'.
    LS_TOOLBAR-BUTN_TYPE = 3.
    APPEND LS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.

* Add button to close the grid
    CLEAR LS_TOOLBAR.
    LS_TOOLBAR-FUNCTION = 'CLOSE_GRID'.
    LS_TOOLBAR-ICON = '@3X@'.
    LS_TOOLBAR-QUICKINFO = 'Close Grid'(m05).
    LS_TOOLBAR-TEXT = 'Close'(m06).
    LS_TOOLBAR-BUTN_TYPE = 0.
    LS_TOOLBAR-DISABLED = SPACE.
    APPEND LS_TOOLBAR TO E_OBJECT->MT_TOOLBAR.
  ENDMETHOD.                    "hnd_result_toolbar

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_result_user_command
*&---------------------------------------------------------------------*
*       Handle grid user command to manage specific fcode
*       (menus & toolbar)
*----------------------------------------------------------------------*
  METHOD HND_RESULT_USER_COMMAND.
    IF E_UCOMM = 'CLOSE_GRID'.
      CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
        EXPORTING
          ID     = 1
          HEIGHT = 100.
    ENDIF.
  ENDMETHOD. "hnd_result_user_command

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_ddic_drag
*&---------------------------------------------------------------------*
*       Handle drag on DDIC field (store fieldname)
*----------------------------------------------------------------------*
  METHOD HND_DDIC_DRAG.
    DATA : LO_DRAG_OBJECT TYPE REF TO LCL_DRAG_OBJECT,
           LS_NODE        LIKE LINE OF S_TAB_ACTIVE-T_NODE_DDIC,
           LW_TEXT        TYPE STRING.

    READ TABLE S_TAB_ACTIVE-T_NODE_DDIC INTO LS_NODE
               WITH KEY NODE_KEY = NODE_KEY.
    IF SY-SUBRC NE 0 OR LS_NODE-ISFOLDER = ABAP_TRUE. "may not append
      MESSAGE 'Only fields can be drag&drop to editor'(m34)
               TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
      RETURN.
    ENDIF.

* Get text for the node selected
    PERFORM DDIC_GET_FIELD_FROM_NODE USING NODE_KEY LS_NODE-RELATKEY
                                     CHANGING LW_TEXT.

* Store the node text
    CREATE OBJECT LO_DRAG_OBJECT.
    LO_DRAG_OBJECT->FIELD = LW_TEXT.
    DRAG_DROP_OBJECT->OBJECT = LO_DRAG_OBJECT.

  ENDMETHOD."hnd_ddic_drag

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_editor_drop
*&---------------------------------------------------------------------*
*       Handle drop on SQL Editor : paste fieldname at cursor position
*----------------------------------------------------------------------*
  METHOD HND_EDITOR_DROP.
    DATA LO_DRAG_OBJECT TYPE REF TO LCL_DRAG_OBJECT.

    LO_DRAG_OBJECT ?= DRAGDROP_OBJECT->OBJECT.
    IF LO_DRAG_OBJECT IS INITIAL OR LO_DRAG_OBJECT->FIELD IS INITIAL.
      RETURN.
    ENDIF.

* Paste fieldname to editor at drop position
    PERFORM EDITOR_PASTE USING LO_DRAG_OBJECT->FIELD LINE POS.

  ENDMETHOD."hnd_editor_drop

*&---------------------------------------------------------------------*
*&      CLASS lcl_application
*&      METHOD hnd_ddic_toolbar_clic
*&---------------------------------------------------------------------*
*       Handle DDIC toolbar button clic
*----------------------------------------------------------------------*
  METHOD HND_DDIC_TOOLBAR_CLIC.

    CASE FCODE.
      WHEN 'REFRESH'.
        PERFORM DDIC_REFRESH_TREE.
      WHEN 'FIND'.
        PERFORM DDIC_FIND_IN_TREE.
      WHEN 'F4'.
        PERFORM DDIC_F4.
    ENDCASE.
  ENDMETHOD.                    "hnd_ddic_toolbar_clic

ENDCLASS.                    "lcl_application IMPLEMENTATION


*######################################################################*
*
*                             MAIN SECTION
*
*######################################################################*
START-OF-SELECTION.
  CALL SCREEN 10.


*######################################################################*
*
*                             PBO SECTION
*
*######################################################################*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0010  OUTPUT
*&---------------------------------------------------------------------*
*       Set status for main screen
*       and initialize custom container at first run
*----------------------------------------------------------------------*
MODULE STATUS_0010 OUTPUT.
* Initialization of object screen
  IF O_CONTAINER IS INITIAL.
    PERFORM SCREEN_INIT.
    APPEND S_TAB_ACTIVE TO T_TABS.
  ENDIF.

  PERFORM SET_STATUS_010.

ENDMODULE.                 " STATUS_0010  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       Set status for modal box (save query)
*----------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.

* Fill dropdown listbox with values
  PERFORM SCREEN_INIT_LISTBOX_0200.

  SET PF-STATUS 'STATUS200'.
  SET TITLEBAR 'STATUS200'.

ENDMODULE.                 " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       Set status for modal box (options)
*----------------------------------------------------------------------*
MODULE STATUS_0300 OUTPUT.

* Create option screen
  IF O_CONTAINER_OPTIONS IS INITIAL.
    PERFORM OPTIONS_INIT.
  ENDIF.

  SET PF-STATUS 'STATUS300'.
  SET TITLEBAR 'STATUS300'.

ENDMODULE.                 " STATUS_0200  OUTPUT

*######################################################################*
*
*                             PAI SECTION
*
*######################################################################*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0010  INPUT
*&---------------------------------------------------------------------*
*       User command for main screen
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0010 INPUT.
  CASE W_OKCODE.
    WHEN 'EXIT'.
      PERFORM SCREEN_EXIT.
    WHEN 'EXECUTE'.
      PERFORM QUERY_PROCESS USING SPACE SPACE.
    WHEN 'DOWNLOAD'.
      PERFORM QUERY_PROCESS USING SPACE ABAP_TRUE.
    WHEN 'SAVE'.
      PERFORM REPO_SAVE_QUERY.
    WHEN 'SHOWCODE'.
      PERFORM QUERY_PROCESS USING ABAP_TRUE SPACE.
    WHEN 'HELP'.
      PERFORM SCREEN_DISPLAY_HELP.
    WHEN 'OPTIONS'.
      PERFORM OPTIONS_DISPLAY.
    WHEN 'NEW'.
      PERFORM TAB_NEW.
    WHEN 'XML'.
      PERFORM EXPORT_XML.
    WHEN 'XMLI'.
      PERFORM IMPORT_XML.
    WHEN OTHERS.
      IF W_OKCODE(3) = 'TAB' AND W_TABSTRIP-ACTIVETAB NE W_OKCODE.
        PERFORM LEAVE_CURRENT_TAB.

        READ TABLE T_TABS INTO S_TAB_ACTIVE INDEX W_OKCODE+3.
* Display editor / ddic / alv
        CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_VISIBLE
          EXPORTING
            VISIBLE = ABAP_TRUE.
        CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->SET_VISIBLE
          EXPORTING
            VISIBLE = ABAP_TRUE.
        IF NOT S_TAB_ACTIVE-O_ALV_RESULT IS INITIAL.
          CALL METHOD S_TAB_ACTIVE-O_ALV_RESULT->SET_VISIBLE
            EXPORTING
              VISIBLE = ABAP_TRUE.
        ENDIF.
        CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
          EXPORTING
            ID     = 1
            HEIGHT = S_TAB_ACTIVE-ROW_HEIGHT.
        W_TABSTRIP-ACTIVETAB = W_OKCODE.
      ENDIF.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0010  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       PAI module for modal box (save query)
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  CASE W_OKCODE.
    WHEN 'CLOSE'.
      CLEAR S_OPTIONS.
      LEAVE TO SCREEN 0.
    WHEN 'OK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       PAI module for modal box (options)
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0300 INPUT.
  CASE W_OKCODE.
    WHEN 'CLOSE' OR 'OK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0200  INPUT

*######################################################################*
*
*                             FORM SECTION
*
*######################################################################*

*&---------------------------------------------------------------------*
*&      Form  SCREEN_INIT
*&---------------------------------------------------------------------*
*       Initialize all objects on the screen
*----------------------------------------------------------------------*
FORM SCREEN_INIT.
* Get user default values
  PERFORM OPTIONS_LOAD.

* Create the handle object (required to catch events)
  CREATE OBJECT O_HANDLE_EVENT.

* Split the screen into 4 parts
  PERFORM SCREEN_INIT_SPLITTER.

* Init History Tree
  PERFORM REPO_INIT.

* Init DDIC toolbar
  PERFORM DDIC_TOOLBAR_INIT.

* Init DDic tree
  PERFORM DDIC_INIT.

* Init Query editor
  PERFORM EDITOR_INIT.

* Init ALV result object
  PERFORM RESULT_INIT.

ENDFORM.                    " SCREEN_INIT

*&---------------------------------------------------------------------*
*&      Form  SCREEN_INIT_SPLITTER
*&---------------------------------------------------------------------*
*       Split the main screen in 2 lines
* 1 line with 3 columns : Repository tree / Query code / Ddic tree
* 1 line with ALV result
*----------------------------------------------------------------------*
FORM SCREEN_INIT_SPLITTER.

* Create the custom container
  CREATE OBJECT O_CONTAINER
    EXPORTING
      CONTAINER_NAME = 'CUSTCONT'.

* Insert splitter into this container
  CREATE OBJECT O_SPLITTER
    EXPORTING
      PARENT  = O_CONTAINER
      ROWS    = 2
      COLUMNS = 1.

* Get the first row of the main splitter
  CALL METHOD O_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 1
    RECEIVING
      CONTAINER = O_CONTAINER_TOP.

*  Spliter for the high part (first row)
  CREATE OBJECT O_SPLITTER_TOP
    EXPORTING
      PARENT  = O_CONTAINER_TOP
      ROWS    = 1
      COLUMNS = 3.

* Get the right part of the top part
  CALL METHOD O_SPLITTER_TOP->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 3
    RECEIVING      "container = o_container_ddic.
      CONTAINER = O_CONTAINER_TOP_RIGHT.

* Add a toolbar to the DDIC container
  CREATE OBJECT O_SPLITTER_TOP_RIGHT
    EXPORTING
      I_R_CONTAINER = O_CONTAINER_TOP_RIGHT.

* Affect an object to each "cell" of the high sub splitter
  CALL METHOD O_SPLITTER_TOP->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 1
    RECEIVING
      CONTAINER = O_CONTAINER_REPOSITORY.

  CALL METHOD O_SPLITTER_TOP->GET_CONTAINER
    EXPORTING
      ROW       = 1
      COLUMN    = 2
    RECEIVING
      CONTAINER = O_CONTAINER_QUERY.

  CALL METHOD O_SPLITTER_TOP_RIGHT->GET_CONTROLCONTAINER
    RECEIVING
      E_R_CONTAINER_CONTROL = O_CONTAINER_DDIC.

  CALL METHOD O_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 2
      COLUMN    = 1
    RECEIVING
      CONTAINER = O_CONTAINER_RESULT.

* Initial repartition :
*   line 1 = 100% (code+repo+ddic)
*   line 2 = 0% (result)
*   line 1 col 1 & 3 = 20% (repo & ddic)
*   line 1 col 2 = 60% (code)
  CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
    EXPORTING
      ID     = 1
      HEIGHT = 100.

  CALL METHOD O_SPLITTER_TOP->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 1
      WIDTH = 20.
  CALL METHOD O_SPLITTER_TOP->SET_COLUMN_WIDTH
    EXPORTING
      ID    = 3
      WIDTH = 20.

ENDFORM.                    " SCREEN_INIT_SPLITTER

*&---------------------------------------------------------------------*
*&      Form  ddic_toolbar_init
*&---------------------------------------------------------------------*
*       Initialize DDIC Toolbar
*
*----------------------------------------------------------------------*
FORM DDIC_TOOLBAR_INIT.
  DATA: LT_BUTTON TYPE TTB_BUTTON,
        LS_BUTTON LIKE LINE OF LT_BUTTON,
        LT_EVENTS TYPE CNTL_SIMPLE_EVENTS,
        LS_EVENTS LIKE LINE OF LT_EVENTS.

*  Toolbar already created by class CL_RSAWB_SPLITTER_FOR_TOOLBAR
  O_TOOLBAR = O_SPLITTER_TOP_RIGHT->GET_TOOLBAR( ).

* Add buttons to toolbar
  CLEAR LS_BUTTON.
  LS_BUTTON-FUNCTION = 'REFRESH'.
  LS_BUTTON-ICON = '@42@'.
  LS_BUTTON-QUICKINFO = 'Refresh DDIC tree'(m41).
  LS_BUTTON-TEXT = 'Refresh'(m40).
  LS_BUTTON-BUTN_TYPE = 0.
  APPEND LS_BUTTON TO LT_BUTTON.

  CLEAR LS_BUTTON.
  LS_BUTTON-FUNCTION = 'FIND'.
  LS_BUTTON-ICON = '@13@'.
  LS_BUTTON-QUICKINFO = 'Search in DDIC tree'(m43).
  LS_BUTTON-TEXT = 'Find'(m42).
  LS_BUTTON-BUTN_TYPE = 0.
  APPEND LS_BUTTON TO LT_BUTTON.

  CLEAR LS_BUTTON.
  LS_BUTTON-FUNCTION = 'F4'.
  LS_BUTTON-ICON = '@6T@'.
  LS_BUTTON-QUICKINFO = 'Display values of sel. field'(m54).
  LS_BUTTON-TEXT = 'Value list'(m55).
  LS_BUTTON-BUTN_TYPE = 0.
  APPEND LS_BUTTON TO LT_BUTTON.

  CALL METHOD O_TOOLBAR->ADD_BUTTON_GROUP
    EXPORTING
      DATA_TABLE = LT_BUTTON.

* Register events
  LS_EVENTS-EVENTID = CL_GUI_TOOLBAR=>M_ID_FUNCTION_SELECTED.
  LS_EVENTS-APPL_EVENT = SPACE.
  APPEND LS_EVENTS TO LT_EVENTS.
  CALL METHOD O_TOOLBAR->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS = LT_EVENTS.

  SET HANDLER O_HANDLE_EVENT->HND_DDIC_TOOLBAR_CLIC FOR O_TOOLBAR.

ENDFORM.                    "ddic_toolbar_init

*&---------------------------------------------------------------------*
*&      Form  EDITOR_INIT
*&---------------------------------------------------------------------*
*       Initialize the sql editor object
*       Fill it with last query, or template if no previous query
*----------------------------------------------------------------------*
FORM EDITOR_INIT.
  DATA : LT_EVENTS     TYPE CNTL_SIMPLE_EVENTS,
         LS_EVENT      TYPE CNTL_SIMPLE_EVENT,
         LT_DEFAULT    TYPE TABLE OF STRING,
         LW_QUERYID    TYPE ZTOAD-QUERYID,
         LO_DRAGROP    TYPE REF TO CL_DRAGDROP,
         LW_DUMMY_DATE TYPE TIMESTAMP.                      "#EC NEEDED

* For first tab, Get last query used
  IF T_TABS IS INITIAL.
    CONCATENATE SY-UNAME '#%' INTO LW_QUERYID.
* aedat is not used but added in select for compatibility reason
    SELECT QUERYID AEDAT
           INTO (LW_QUERYID, LW_DUMMY_DATE)
           FROM ZTOAD
           UP TO 1 ROWS
           WHERE QUERYID LIKE LW_QUERYID
           AND OWNER = SY-UNAME
           ORDER BY AEDAT DESCENDING.
    ENDSELECT.
    IF SY-SUBRC = 0.
      PERFORM QUERY_LOAD USING LW_QUERYID
                         CHANGING LT_DEFAULT.
      PERFORM REPO_FOCUS_QUERY USING LW_QUERYID.
    ENDIF.
  ENDIF.

* If no last query found, use default template
  IF LT_DEFAULT IS INITIAL.
    PERFORM EDITOR_GET_DEFAULT_QUERY CHANGING LT_DEFAULT.
  ENDIF.

* Create the sql editor
*  CREATE OBJECT s_tab_active-o_container_query
*    EXPORTING
*      parent = o_container_query.

  CREATE OBJECT S_TAB_ACTIVE-O_TEXTEDIT
    EXPORTING
      PARENT = O_CONTAINER_QUERY.

* Register events
  SET HANDLER O_HANDLE_EVENT->HND_EDITOR_F1 FOR S_TAB_ACTIVE-O_TEXTEDIT.
  SET HANDLER O_HANDLE_EVENT->HND_EDITOR_DROP FOR S_TAB_ACTIVE-O_TEXTEDIT.

  LS_EVENT-EVENTID = CL_GUI_TEXTEDIT=>EVENT_F1.
  APPEND LS_EVENT TO LT_EVENTS.

  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS                    = LT_EVENTS
    EXCEPTIONS
      CNTL_ERROR                = 1
      CNTL_SYSTEM_ERROR         = 2
      ILLEGAL_EVENT_COMBINATION = 3.
  IF SY-SUBRC <> 0.
    IF SY-MSGNO IS NOT INITIAL.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              DISPLAY LIKE C_MSG_ERROR
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 .
    ENDIF.
  ENDIF.

* Activate Code Completion and Quickinfo
* Comment the paragraph if CL_ABAP_PARSER doesnt exists on your system
* BEGIN OF ABAP PARSER
  DATA LO_COMPLETER TYPE REF TO CL_ABAP_PARSER.
  CALL METHOD s_tab_active-o_textedit->('INIT_COMPLETER').
  CALL METHOD s_tab_active-o_textedit->('GET_COMPLETER')
    RECEIVING
      M_PARSER = LO_COMPLETER.
  SET HANDLER LO_COMPLETER->HANDLE_COMPLETION_REQUEST FOR S_TAB_ACTIVE-O_TEXTEDIT.
  SET HANDLER LO_COMPLETER->HANDLE_INSERTION_REQUEST FOR S_TAB_ACTIVE-O_TEXTEDIT.
  SET HANDLER LO_COMPLETER->HANDLE_QUICKINFO_REQUEST FOR S_TAB_ACTIVE-O_TEXTEDIT.
  S_TAB_ACTIVE-O_TEXTEDIT->REGISTER_EVENT_COMPLETION( ).
  S_TAB_ACTIVE-O_TEXTEDIT->REGISTER_EVENT_QUICK_INFO( ).
  S_TAB_ACTIVE-O_TEXTEDIT->REGISTER_EVENT_INSERT_PATTERN( ).
* END OF ABAP PARSER

* Manage Drop on SQL editor
  CREATE OBJECT LO_DRAGROP.
  CALL METHOD LO_DRAGROP->ADD
    EXPORTING
      FLAVOR     = 'EDIT_INSERT'
      DRAGSRC    = SPACE
      DROPTARGET = ABAP_TRUE
      EFFECT     = CL_DRAGDROP=>COPY.
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_DRAGDROP
    EXPORTING
      DRAGDROP = LO_DRAGROP.

* Set Default template
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_TEXT
    EXPORTING
      TABLE  = LT_DEFAULT
    EXCEPTIONS
      OTHERS = 0.

* Set focus
  CALL METHOD CL_GUI_CONTROL=>SET_FOCUS
    EXPORTING
      CONTROL = S_TAB_ACTIVE-O_TEXTEDIT
    EXCEPTIONS
      OTHERS  = 0.

  PERFORM DDIC_REFRESH_TREE.
ENDFORM.                    " EDITOR_INIT

*&---------------------------------------------------------------------*
*&      Form  query_process
*&---------------------------------------------------------------------*
*       Process selected query : execute or display code
*----------------------------------------------------------------------*
*      -->FW_DISPLAY : Flag abap_true to display code
*      -->FW_DOWNLOAD: Flag abap_true to save results into file
*----------------------------------------------------------------------*
FORM QUERY_PROCESS USING FW_DISPLAY TYPE C
                         FW_DOWNLOAD TYPE C.
  DATA : LW_QUERY         TYPE STRING,
         LW_SELECT        TYPE STRING,
         LW_FROM          TYPE STRING,
         LW_WHERE         TYPE STRING,
         LW_UNION         TYPE STRING,
         LW_QUERY2        TYPE STRING,
         LW_COMMAND       TYPE STRING,
         LW_ROWS(6)       TYPE N,
         LW_PROGRAM       TYPE SY-REPID,
         LO_RESULT        TYPE REF TO DATA,
         LO_RESULT2       TYPE REF TO DATA,
         LT_FIELDLIST     TYPE TY_FIELDLIST_TABLE,
         LT_FIELDLIST2    TYPE TY_FIELDLIST_TABLE,
         LT_SELECT_TABLE  TYPE SOLI_TAB,
         LW_COUNT_ONLY(1) TYPE C,
         LW_TIME          TYPE P LENGTH 8 DECIMALS 2,
         LW_TIME2         LIKE LW_TIME,
         LW_COUNT         TYPE I,
         LW_COUNT2        LIKE LW_COUNT,
         LW_CHARNUMB(12)  TYPE C,
         LW_MSG           TYPE STRING,
         LW_NOAUTH(1)     TYPE C,
         LW_NEWSYNTAX(1)  TYPE C,
         LW_ANSWER(1)     TYPE C,
         LW_FROM_CONCAT   LIKE LW_FROM,
         LW_ERROR(1)      TYPE C.

  FIELD-SYMBOLS : <LFT_DATA>  TYPE STANDARD TABLE,
                  <LFT_DATA2> TYPE STANDARD TABLE.

* Get only usefull code for current query
  PERFORM EDITOR_GET_QUERY USING SPACE CHANGING LW_QUERY LT_SELECT_TABLE.

* Parse SELECT Query
  PERFORM QUERY_PARSE USING LW_QUERY
                      CHANGING LW_SELECT LW_FROM LW_WHERE
                               LW_UNION LW_ROWS LW_NOAUTH
                               LW_NEWSYNTAX LW_ERROR.
  IF LW_ERROR NE SPACE.
    MESSAGE 'Cannot parse the query'(m07) TYPE C_MSG_ERROR.
  ENDIF.

* Not a select query
  IF LW_SELECT IS INITIAL.
    PERFORM QUERY_PARSE_NOSELECT USING    LW_QUERY
                                 CHANGING LW_NOAUTH
                                          LW_COMMAND
                                          LW_FROM
                                          LW_WHERE.
    IF LW_NOAUTH NE SPACE.
      PERFORM DDIC_SET_TREE USING LW_FROM.
      RETURN.
    ENDIF.

* For native sql command, execute it directly
    IF LW_COMMAND = C_NATIVE_COMMAND.
      PERFORM DDIC_SET_TREE USING LW_FROM.
      PERFORM QUERY_PROCESS_NATIVE USING LW_WHERE.
      RETURN.
    ENDIF.

* For other no select command, generate program
    IF W_RUN LT C_QUERY_MAX_EXEC.
      PERFORM QUERY_GENERATE_NOSELECT USING LW_COMMAND LW_FROM
                                            LW_WHERE FW_DISPLAY
                                      CHANGING LW_PROGRAM.
      W_RUN = W_RUN + 1.
    ELSE.
      MESSAGE 'No more run available. Please restart program'(m50)
              TYPE C_MSG_ERROR.
    ENDIF.
    IF FW_DISPLAY IS INITIAL.
      PERFORM DDIC_SET_TREE USING LW_FROM.
      CONCATENATE 'Are you sure you want to do a'(m31) LW_COMMAND
                  'on table'(m32) LW_FROM '?'(m33)
                  INTO LW_MSG SEPARATED BY SPACE.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR              = 'Warning : critical operation'(t04)
          TEXT_QUESTION         = LW_MSG
          DEFAULT_BUTTON        = '2'
          DISPLAY_CANCEL_BUTTON = SPACE
        IMPORTING
          ANSWER                = LW_ANSWER
        EXCEPTIONS
          TEXT_NOT_FOUND        = 1
          OTHERS                = 2.
      IF SY-SUBRC NE 0 OR LW_ANSWER NE '1'.
        RETURN.
      ENDIF.
    ENDIF.
    LW_COUNT_ONLY = ABAP_TRUE. "no result grid to display
  ELSEIF LW_NOAUTH NE SPACE.
    PERFORM DDIC_SET_TREE USING LW_FROM.
    RETURN.
  ELSEIF LW_FROM IS INITIAL.
    PERFORM DDIC_SET_TREE USING LW_FROM.
    MESSAGE 'Cannot parse the query'(m07) TYPE C_MSG_ERROR.
  ELSE.
* Generate SELECT subroutine
    IF W_RUN LT C_QUERY_MAX_EXEC.
      PERFORM QUERY_GENERATE USING LW_SELECT LW_FROM
                                   LW_WHERE FW_DISPLAY
                                   LW_NEWSYNTAX
                                   LW_QUERY
                             CHANGING LW_PROGRAM LW_ROWS
                                      LT_FIELDLIST LW_COUNT_ONLY
                                      LT_SELECT_TABLE.
      IF LW_PROGRAM IS INITIAL.
        PERFORM DDIC_SET_TREE USING LW_FROM.
        RETURN.
      ENDIF.
      W_RUN = W_RUN + 1.
    ELSE.
      MESSAGE 'No more run available. Please restart program'(m50)
              TYPE C_MSG_ERROR.
    ENDIF.
  ENDIF.


* Call the generated subroutine
  IF NOT LW_PROGRAM IS INITIAL.
    PERFORM RUN_SQL IN PROGRAM (LW_PROGRAM)
                    CHANGING LO_RESULT LW_TIME LW_COUNT.
    LW_FROM_CONCAT = LW_FROM.
* For union, process second (and further) query
    WHILE NOT LW_UNION IS INITIAL.
* Parse Query
      LW_QUERY2 = LW_UNION.
      PERFORM QUERY_PARSE USING LW_QUERY2
                          CHANGING LW_SELECT LW_FROM LW_WHERE
                                   LW_UNION LW_ROWS LW_NOAUTH
                                   LW_NEWSYNTAX LW_ERROR.
      CONCATENATE LW_FROM_CONCAT 'JOIN' LW_FROM INTO LW_FROM_CONCAT.
      IF LW_NOAUTH NE SPACE.
        PERFORM DDIC_SET_TREE USING LW_FROM_CONCAT.
        RETURN.
      ELSEIF LW_SELECT IS INITIAL OR LW_FROM IS INITIAL
      OR LW_ERROR = ABAP_TRUE.
        PERFORM DDIC_SET_TREE USING LW_FROM_CONCAT.
        MESSAGE 'Cannot parse the unioned query'(m08) TYPE C_MSG_ERROR.
        EXIT. "exit while
      ENDIF.
* Generate subroutine
      IF W_RUN LT C_QUERY_MAX_EXEC.
        PERFORM QUERY_GENERATE USING LW_SELECT LW_FROM
                                     LW_WHERE FW_DISPLAY
                                     LW_NEWSYNTAX
                                     LW_QUERY
                               CHANGING LW_PROGRAM LW_ROWS
                                        LT_FIELDLIST2 LW_COUNT_ONLY LT_SELECT_TABLE.
        IF LW_PROGRAM IS INITIAL.
          PERFORM DDIC_SET_TREE USING LW_FROM_CONCAT.
          RETURN.
        ENDIF.
        W_RUN = W_RUN + 1.
      ELSE.
        MESSAGE 'No more run available. Please restart program'(m50)
                TYPE C_MSG_ERROR.
      ENDIF.
* Call the generated subroutine
      PERFORM RUN_SQL IN PROGRAM (LW_PROGRAM)
                      CHANGING LO_RESULT2 LW_TIME2 LW_COUNT2.

* Append lines of the further queries to the first query
      ASSIGN LO_RESULT->* TO <LFT_DATA>.
      ASSIGN LO_RESULT2->* TO <LFT_DATA2>.
      APPEND LINES OF <LFT_DATA2> TO <LFT_DATA>.
      REFRESH <LFT_DATA2>.
      LW_TIME = LW_TIME + LW_TIME2.
      LW_COUNT = LW_COUNT + LW_COUNT2.
    ENDWHILE.

    PERFORM DDIC_SET_TREE USING LW_FROM_CONCAT.

* Display message
    LW_CHARNUMB = LW_TIME.
    CONCATENATE 'Query executed in'(m09) LW_CHARNUMB INTO LW_MSG
                SEPARATED BY SPACE.
    LW_CHARNUMB = LW_COUNT.
    IF NOT LW_SELECT IS INITIAL.
      CONCATENATE LW_MSG 'seconds.'(m10)
                  LW_CHARNUMB 'entries found'(m11)
                  INTO LW_MSG SEPARATED BY SPACE.
    ELSE.
      CONCATENATE LW_MSG 'seconds.'(m10)
                  LW_CHARNUMB 'entries affected'(m12)
                  INTO LW_MSG SEPARATED BY SPACE.
    ENDIF.
    CONDENSE LW_MSG.
    MESSAGE LW_MSG TYPE C_MSG_SUCCESS.


* Display result except for count(*)
    IF LW_COUNT_ONLY IS INITIAL.
      IF FW_DOWNLOAD = SPACE.
        PERFORM RESULT_DISPLAY USING LO_RESULT LT_FIELDLIST LW_QUERY.
      ELSE.
        PERFORM RESULT_SAVE_FILE USING LO_RESULT LT_FIELDLIST.
      ENDIF.
    ENDIF.

    PERFORM REPO_SAVE_CURRENT_QUERY.
  ENDIF.
ENDFORM.                    " QUERY_PROCESS

*&---------------------------------------------------------------------*
*&      Form  EDITOR_GET_QUERY
*&---------------------------------------------------------------------*
*       Return active query without comment
*----------------------------------------------------------------------*
*      -->FW_FORCE_LAST  Keep last request
*      <--FW_QUERY       Query code
*----------------------------------------------------------------------*
FORM EDITOR_GET_QUERY USING FW_FORCE_LAST TYPE C
                      CHANGING FW_QUERY TYPE STRING
                               LT_SELECT_TABLE TYPE SOLI_TAB.
  DATA : LT_QUERY         TYPE SOLI_TAB,
         LS_QUERY         LIKE LINE OF LT_QUERY,
         LS_FIND          TYPE MATCH_RESULT,
         LT_FIND          TYPE MATCH_RESULT_TAB,
         LT_FIND_SUB      TYPE MATCH_RESULT_TAB,
         LW_LINES         TYPE I,
         LW_CURSOR_LINE   TYPE I,
         LW_CURSOR_POS    TYPE I,
         LW_DELTO_LINE    TYPE I,
         LW_DELTO_POS     TYPE I,
         LW_CURSOR_OFFSET TYPE I,
         LW_LAST          TYPE C.

  CLEAR FW_QUERY.

* Get selected content
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_SELECTED_TEXT_AS_TABLE
    IMPORTING
      TABLE = LT_QUERY[].

* if no selected content, get complete content of abap edit box
  IF LT_QUERY[] IS INITIAL.
    CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXT
      IMPORTING
        TABLE  = LT_QUERY[]
      EXCEPTIONS
        OTHERS = 1.
  ENDIF.

  LT_SELECT_TABLE[] = LT_QUERY[].

* Remove * comment
  LOOP AT LT_QUERY INTO LS_QUERY WHERE LINE(1) = '*'.
    CLEAR LS_QUERY-LINE.
    MODIFY LT_QUERY FROM LS_QUERY.
  ENDLOOP.

* Remove " comment
  LOOP AT LT_QUERY INTO LS_QUERY WHERE LINE CS '"'.
*    condense ls_query-line.
    FIND ALL OCCURRENCES OF '"' IN LS_QUERY-LINE RESULTS LT_FIND.
    IF SY-SUBRC NE 0. "may not occurs
      CONTINUE.
    ENDIF.
    LOOP AT LT_FIND INTO LS_FIND.
      IF LS_FIND-OFFSET GT 0.
* Search open '
        FIND ALL OCCURRENCES OF '''' IN LS_QUERY-LINE(LS_FIND-OFFSET)
             RESULTS LT_FIND_SUB.
        IF SY-SUBRC = 0.
          DESCRIBE TABLE LT_FIND_SUB LINES LW_LINES.
          LW_LINES = LW_LINES MOD 2.
          IF LW_LINES = 1.
            CONTINUE.
          ENDIF.
        ENDIF.
        LS_QUERY-LINE = LS_QUERY-LINE(LS_FIND-OFFSET).
        EXIT. "exit loop
      ELSE.
        CLEAR LS_QUERY-LINE.
        EXIT. "exit loop
      ENDIF.
    ENDLOOP.
    MODIFY LT_QUERY FROM LS_QUERY.
  ENDLOOP.

* Find active query
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_SELECTION_POS
    IMPORTING
      FROM_LINE = LW_CURSOR_LINE
      FROM_POS  = LW_CURSOR_POS.
  LW_CURSOR_OFFSET = LW_CURSOR_POS - 1.

  FIND ALL OCCURRENCES OF '.' IN TABLE LT_QUERY RESULTS LT_FIND.
  CLEAR : LW_DELTO_LINE,
          LW_DELTO_POS,
          LW_LAST.
  LOOP AT LT_FIND INTO LS_FIND.
    AT LAST.
      LW_LAST = ABAP_TRUE.
    ENDAT.
* Search for open '
    IF LS_FIND-OFFSET GT 0.
      READ TABLE LT_QUERY INTO LS_QUERY INDEX LS_FIND-LINE.
      FIND ALL OCCURRENCES OF '''' IN LS_QUERY(LS_FIND-OFFSET)
           RESULTS LT_FIND_SUB.
      DESCRIBE TABLE LT_FIND_SUB LINES LW_LINES.
      LW_LINES = LW_LINES MOD 2.
* If open ' found, ignore the dot
      IF LW_LINES = 1.
        CONTINUE.
      ENDIF.
    ENDIF.

* Active Query
    IF LS_FIND-LINE GT LW_CURSOR_LINE
    OR ( LS_FIND-LINE = LW_CURSOR_LINE
         AND LS_FIND-OFFSET GE LW_CURSOR_OFFSET )
    OR ( LW_LAST = ABAP_TRUE AND FW_FORCE_LAST = ABAP_TRUE ).
* Delete all query after query active
      LS_FIND-LINE = LS_FIND-LINE + 1.
      DELETE LT_QUERY FROM LS_FIND-LINE.
      LS_FIND-LINE = LS_FIND-LINE - 1.
* Do not keep the . for active query
      IF LS_FIND-OFFSET = 0.
        DELETE LT_QUERY FROM LS_FIND-LINE.
      ELSE.
        LS_QUERY-LINE = LS_QUERY-LINE(LS_FIND-OFFSET).
        MODIFY LT_QUERY FROM LS_QUERY INDEX LS_FIND-LINE.
      ENDIF.
      EXIT.
* Query before active
    ELSE.
      LW_DELTO_LINE = LS_FIND-LINE.
      LW_DELTO_POS = LS_FIND-OFFSET + 1.
    ENDIF.
  ENDLOOP.

* Delete all query before query active
  IF NOT LW_DELTO_LINE IS INITIAL.
    IF LW_DELTO_LINE GT 1.
      LW_DELTO_LINE = LW_DELTO_LINE - 1.
      DELETE LT_QUERY FROM 1 TO LW_DELTO_LINE.
    ENDIF.
    READ TABLE LT_QUERY INTO LS_QUERY INDEX 1.
    LS_QUERY-LINE(LW_DELTO_POS) = ''.
    MODIFY LT_QUERY FROM LS_QUERY INDEX 1.
  ENDIF.

* Delete empty lines
  DELETE LT_QUERY WHERE LINE CO ' .'.

* Build query string & Remove unnessential spaces
  LOOP AT LT_QUERY INTO LS_QUERY.
    CONDENSE LS_QUERY-LINE.
    SHIFT LS_QUERY-LINE LEFT DELETING LEADING SPACE.
    CONCATENATE FW_QUERY LS_QUERY-LINE INTO FW_QUERY SEPARATED BY SPACE.
  ENDLOOP.
  IF NOT FW_QUERY IS INITIAL.
    FW_QUERY = FW_QUERY+1.
  ENDIF.

* If no query selected, try to get the last one
  IF LT_QUERY IS INITIAL AND FW_FORCE_LAST = SPACE.
    PERFORM EDITOR_GET_QUERY USING ABAP_TRUE
                             CHANGING FW_QUERY LT_SELECT_TABLE.
  ENDIF.
ENDFORM.                    " EDITOR_GET_QUERY

*&---------------------------------------------------------------------*
*&      Form  QUERY_PARSE
*&---------------------------------------------------------------------*
*       Split the query into 3 parts : Select / From / Where
*       - Select : List of the fields to extract
*       - From   : List of the tables - with join condition
*       - Where  : List of filters + group, order, having clauses
*----------------------------------------------------------------------*
*      -->FW_QUERY   Query to parse
*      <--FW_SELECT  Select part of the query
*      <--FW_FROM    From part of the query
*      <--FW_WHERE   Where part of the query
*      <--FW_ROWS    Number of rows to display
*      <--FW_UNION   Union part of the query
*      <--FW_NOAUTH  Unallowed table entered
*      <--FW_NEWSYNTAX Use new SQL syntax introduced with NW7.40 SP5
*      <--FW_ERROR   Cannot parse the query
*----------------------------------------------------------------------*
FORM QUERY_PARSE  USING    FW_QUERY TYPE STRING
                  CHANGING FW_SELECT TYPE STRING
                           FW_FROM TYPE STRING
                           FW_WHERE TYPE STRING
                           FW_UNION TYPE STRING
                           FW_ROWS TYPE N
                           FW_NOAUTH TYPE C
                           FW_NEWSYNTAX TYPE C
                           FW_ERROR TYPE C.

  DATA : LS_FIND_SELECT TYPE MATCH_RESULT,
         LS_FIND_FROM   TYPE MATCH_RESULT,
         LS_FIND_WHERE  TYPE MATCH_RESULT,
         LS_SUB         LIKE LINE OF LS_FIND_SELECT-SUBMATCHES,
         LW_OFFSET      TYPE I,
         LW_LENGTH      TYPE I,
         LW_QUERY       TYPE STRING,
         LO_REGEX       TYPE REF TO CL_ABAP_REGEX,
         LT_SPLIT       TYPE TABLE OF STRING,
         LW_STRING      TYPE STRING,
         LW_TABIX       TYPE I,
         LW_TABLE       TYPE TABNAME.

  CLEAR : FW_SELECT,
          FW_FROM,
          FW_WHERE,
          FW_ROWS,
          FW_UNION,
          FW_NOAUTH,
          FW_NEWSYNTAX.

  LW_QUERY = FW_QUERY.

* Search union
  FIND FIRST OCCURRENCE OF ' UNION SELECT ' IN LW_QUERY
       RESULTS LS_FIND_SELECT IGNORING CASE.
  IF SY-SUBRC = 0.
    LW_OFFSET = LS_FIND_SELECT-OFFSET + 7.
    FW_UNION = LW_QUERY+LW_OFFSET.
    LW_QUERY = LW_QUERY(LS_FIND_SELECT-OFFSET).
  ENDIF.

* Search UP TO xxx ROWS.
* Catch the number of rows, delete command in query
  CREATE OBJECT LO_REGEX
    EXPORTING
      PATTERN     = 'UP TO ([0-9]+) ROWS'
      IGNORE_CASE = ABAP_TRUE.
  FIND FIRST OCCURRENCE OF REGEX LO_REGEX
       IN LW_QUERY RESULTS LS_FIND_SELECT.
  IF SY-SUBRC = 0.
    READ TABLE LS_FIND_SELECT-SUBMATCHES INTO LS_SUB INDEX 1.
    IF SY-SUBRC = 0.
      FW_ROWS = LW_QUERY+LS_SUB-OFFSET(LS_SUB-LENGTH).
    ENDIF.
    REPLACE FIRST OCCURRENCE OF REGEX LO_REGEX IN LW_QUERY WITH ''.
  ELSE.
* Set default number of rows
    FW_ROWS = S_CUSTOMIZE-DEFAULT_ROWS.
  ENDIF.

* Remove unused INTO (CORRESPONDING FIELDS OF)(TABLE)
* Detect new syntax in internal table name
  CONCATENATE '(INTO|APPENDING)( TABLE'
              '| CORRESPONDING FIELDS OF TABLE |'
              'CORRESPONDING FIELDS OF | )(\S*)'
              INTO LW_STRING SEPARATED BY SPACE.
  CREATE OBJECT LO_REGEX
    EXPORTING
      PATTERN     = LW_STRING
      IGNORE_CASE = ABAP_TRUE.
  FIND FIRST OCCURRENCE OF REGEX LO_REGEX
       IN LW_QUERY RESULTS LS_FIND_SELECT.
  IF SY-SUBRC = 0.
    IF LS_FIND_SELECT-LENGTH NE 0
    AND FW_QUERY+LS_FIND_SELECT-OFFSET(LS_FIND_SELECT-LENGTH) CS '@'.
      FW_NEWSYNTAX = ABAP_TRUE.
    ENDIF.
    REPLACE FIRST OCCURRENCE OF REGEX LO_REGEX IN LW_QUERY WITH ''.
  ENDIF.

* Search SELECT
  FIND FIRST OCCURRENCE OF 'SELECT ' IN LW_QUERY
       RESULTS LS_FIND_SELECT IGNORING CASE.
  IF SY-SUBRC NE 0.
    RETURN.
  ENDIF.

* Search FROM
  FIND FIRST OCCURRENCE OF ' FROM '
       IN SECTION OFFSET LS_FIND_SELECT-OFFSET OF LW_QUERY
       RESULTS LS_FIND_FROM IGNORING CASE.
  IF SY-SUBRC NE 0.
    FW_ERROR = ABAP_TRUE.
    RETURN.
  ENDIF.

* Search WHERE / GROUP BY / HAVING / ORDER BY
  FIND FIRST OCCURRENCE OF ' WHERE '
       IN SECTION OFFSET LS_FIND_FROM-OFFSET OF LW_QUERY
       RESULTS LS_FIND_WHERE IGNORING CASE.
  IF SY-SUBRC NE 0.
    FIND FIRST OCCURRENCE OF ' GROUP BY ' IN LW_QUERY
         RESULTS LS_FIND_WHERE IGNORING CASE.
  ENDIF.
  IF SY-SUBRC NE 0.
    FIND FIRST OCCURRENCE OF ' HAVING ' IN LW_QUERY
         RESULTS LS_FIND_WHERE IGNORING CASE.
  ENDIF.
  IF SY-SUBRC NE 0.
    FIND FIRST OCCURRENCE OF ' ORDER BY ' IN LW_QUERY
         RESULTS LS_FIND_WHERE IGNORING CASE.
  ENDIF.

  LW_OFFSET = LS_FIND_SELECT-OFFSET + 7.
  LW_LENGTH = LS_FIND_FROM-OFFSET - LS_FIND_SELECT-OFFSET - 7.
  IF LW_LENGTH LE 0.
    FW_ERROR = ABAP_TRUE.
    RETURN.
  ENDIF.
  FW_SELECT = LW_QUERY+LW_OFFSET(LW_LENGTH).

* Detect new syntax in comma field select separator
  IF FW_SELECT CS ','.
    FW_NEWSYNTAX = ABAP_TRUE.
  ENDIF.

  LW_OFFSET = LS_FIND_FROM-OFFSET + 6.
  IF LS_FIND_WHERE IS INITIAL.
    FW_FROM = LW_QUERY+LW_OFFSET.
    FW_WHERE = ''.
  ELSE.
    LW_LENGTH = LS_FIND_WHERE-OFFSET - LS_FIND_FROM-OFFSET - 6.
    FW_FROM = LW_QUERY+LW_OFFSET(LW_LENGTH).
    LW_OFFSET = LS_FIND_WHERE-OFFSET.
    FW_WHERE = LW_QUERY+LW_OFFSET.
  ENDIF.

* Authority-check on used select tables
  IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE OR S_CUSTOMIZE-AUTH_SELECT NE '*'.
    CONCATENATE 'JOIN' FW_FROM INTO LW_STRING SEPARATED BY SPACE.
    TRANSLATE LW_STRING TO UPPER CASE.
    SPLIT LW_STRING AT SPACE INTO TABLE LT_SPLIT.
    LOOP AT LT_SPLIT INTO LW_STRING.
      LW_TABIX = SY-TABIX + 1.
      CHECK LW_STRING = 'JOIN'.
* Read next line (table name)
      READ TABLE LT_SPLIT INTO LW_TABLE INDEX LW_TABIX.
      CHECK SY-SUBRC = 0.

      IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE.
        AUTHORITY-CHECK OBJECT S_CUSTOMIZE-AUTH_OBJECT
                 ID 'TABLE' FIELD LW_TABLE
                 ID 'ACTVT' FIELD S_CUSTOMIZE-ACTVT_SELECT.
      ELSEIF S_CUSTOMIZE-AUTH_SELECT NE '*'
      AND NOT LW_TABLE CP S_CUSTOMIZE-AUTH_SELECT.
        SY-SUBRC = 4.
      ENDIF.
      IF SY-SUBRC NE 0.
        CONCATENATE 'No authorisation for table'(m13) LW_TABLE
                    INTO LW_STRING SEPARATED BY SPACE.
        MESSAGE LW_STRING TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
        CLEAR FW_FROM.
        FW_NOAUTH = ABAP_TRUE.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " QUERY_PARSE

*&---------------------------------------------------------------------*
*&      Form  add_line_to_table
*&---------------------------------------------------------------------*
*       Add a string line in a table
*       Break line at 255 char, respecting words if possible
*----------------------------------------------------------------------*
*      -->FW_LINE    Line to add in table
*      <--FT_TABLE   Table to append
*----------------------------------------------------------------------*
FORM ADD_LINE_TO_TABLE USING FW_LINE TYPE STRING
                       CHANGING FT_TABLE TYPE TABLE.
  DATA : LW_LENGTH TYPE I,
         LW_OFFSET TYPE I,
         LS_FIND   TYPE MATCH_RESULT.

  LW_LENGTH = STRLEN( FW_LINE ).
  LW_OFFSET = 0.
  DO.
    IF LW_LENGTH LE C_LINE_MAX.
      APPEND FW_LINE+LW_OFFSET(LW_LENGTH) TO FT_TABLE.
      EXIT. "exit do
    ELSE.
      FIND ALL OCCURRENCES OF REGEX '\s' "search space
           IN SECTION OFFSET LW_OFFSET LENGTH C_LINE_MAX
           OF FW_LINE RESULTS LS_FIND.
      IF SY-SUBRC NE 0.
        APPEND FW_LINE+LW_OFFSET(C_LINE_MAX) TO FT_TABLE.
        LW_LENGTH = LW_LENGTH - C_LINE_MAX.
        LW_OFFSET = LW_OFFSET + C_LINE_MAX.
      ELSE.
        LS_FIND-LENGTH = LS_FIND-OFFSET - LW_OFFSET.
        APPEND FW_LINE+LW_OFFSET(LS_FIND-LENGTH) TO FT_TABLE.
        LW_LENGTH = LW_LENGTH + LW_OFFSET - LS_FIND-OFFSET - 1.
        LW_OFFSET = LS_FIND-OFFSET + 1.
      ENDIF.
    ENDIF.
  ENDDO.

ENDFORM.                    "add_line_to_table

*&---------------------------------------------------------------------*
*&      Form  QUERY_GENERATE
*&---------------------------------------------------------------------*
*       Create SELECT SQL query in a new generated temp program
*----------------------------------------------------------------------*
*      -->FW_SELECT    Select part of the query
*      -->FW_FROM      From part of the query
*      -->FW_WHERE     Where part of the query
*      -->FW_DISPLAY   Display code instead of generated routine
*      -->FW_NEWSYNTAX Use new SQL syntax introduced with NW7.40 SP5
*      <--FW_PROGRAM   Name of the generated program
*      <--FW_ROWS      Number of rows to display
*      <--FT_FIELDLIST List of fields to display
*      <--FW_COUNT     = true if query is only count( * )
*----------------------------------------------------------------------*
FORM QUERY_GENERATE  USING    FW_SELECT TYPE STRING
                              FW_FROM TYPE STRING
                              FW_WHERE TYPE STRING
                              FW_DISPLAY TYPE C
                              FW_NEWSYNTAX TYPE C
                              LW_QUERY TYPE STRING
                     CHANGING FW_PROGRAM TYPE SY-REPID
                              FW_ROWS TYPE N
                              FT_FIELDLIST TYPE TY_FIELDLIST_TABLE
                              FW_COUNT TYPE C
                              LT_SELECT_TABLE TYPE SOLI_TAB.

  DATA : LT_CODE_STRING      TYPE TABLE OF STRING,
         LT_SPLIT            TYPE TABLE OF STRING,
         LW_STRING           TYPE STRING,
         LW_STRING2          TYPE STRING,

         LT_TABLE_ALIAS      LIKE TABLE OF LS_TABLE_ALIAS,
         LW_SELECT           TYPE STRING,
         LW_FROM             TYPE STRING,
         LW_INDEX            TYPE I,
         LW_SELECT_DISTINCT  TYPE C,
         LW_SELECT_LENGTH    TYPE I,
         LW_CHAR_10(10)      TYPE C,
         LW_FIELD_NUMBER(6)  TYPE N,
         LW_CURRENT_LINE     TYPE I,
         LW_CURRENT_LENGTH   TYPE I,
         LW_STRUCT_LINE      TYPE STRING,
         LW_STRUCT_LINE_TYPE TYPE STRING,
         LW_SELECT_TABLE     TYPE STRING,
         LW_SELECT_FIELD     TYPE STRING,
         LW_DD03L_FIELDNAME  TYPE DD03L-FIELDNAME,
         LW_POSITION_DUMMY   TYPE DD03L-POSITION,
         LW_MESS(255),
         LW_LINE             TYPE I,
         LW_WORD(30),
         LS_FIELDLIST        TYPE TY_FIELDLIST,
         LW_STRLEN_STRING    TYPE STRING,
         LW_EXPLICIT         TYPE STRING.

  DEFINE C.
    lw_strlen_string = &1.
    perform add_line_to_table using lw_strlen_string
                              changing lt_code_string.
  END-OF-DEFINITION.

  CLEAR : LW_SELECT_DISTINCT,
          FW_COUNT.

* Write Header
  C 'PROGRAM SUBPOOL.'.
  C '** GENERATED PROGRAM * DO NOT CHANGE IT **'.
  C 'TYPE-POOLS: slis.'.                                    "#EC NOTEXT
  C ''.

  LW_SELECT = FW_SELECT.
  TRANSLATE LW_SELECT TO UPPER CASE.

  LW_FROM = FW_FROM.
  TRANSLATE LW_FROM TO UPPER CASE.

* Search special term "single" or "distinct"
  LW_SELECT_LENGTH = STRLEN( LW_SELECT ).
  IF LW_SELECT_LENGTH GE 7.
    LW_CHAR_10 = LW_SELECT(7).
    IF LW_CHAR_10 = 'SINGLE'.
* Force rows number = 1 for select single
      FW_ROWS = 1.
      LW_SELECT = LW_SELECT+7.
      LW_SELECT_LENGTH = LW_SELECT_LENGTH - 7.
    ENDIF.
  ENDIF.
  IF LW_SELECT_LENGTH GE 9.
    LW_CHAR_10 = LW_SELECT(9).
    IF LW_CHAR_10 = 'DISTINCT'.
      LW_SELECT_DISTINCT = ABAP_TRUE.
      LW_SELECT = LW_SELECT+9.
      LW_SELECT_LENGTH = LW_SELECT_LENGTH - 9.
    ENDIF.
  ENDIF.

* Search for special syntax "count( * )"
  IF LW_SELECT = 'COUNT( * )'.
    FW_COUNT = ABAP_TRUE.
  ENDIF.

* Create alias table mapping
  SPLIT LW_FROM AT SPACE INTO TABLE LT_SPLIT.
  LOOP AT LT_SPLIT INTO LW_STRING.
    IF LW_STRING IS INITIAL OR LW_STRING CO SPACE.
      DELETE LT_SPLIT.
    ENDIF.
  ENDLOOP.
  DO.
    READ TABLE LT_SPLIT TRANSPORTING NO FIELDS WITH KEY = 'AS'.
    IF SY-SUBRC NE 0.
      EXIT. "exit do
    ENDIF.
    LW_INDEX = SY-TABIX - 1.
    READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
    LS_TABLE_ALIAS-TABLE = LW_STRING.
    DELETE LT_SPLIT INDEX LW_INDEX. "delete table field
    DELETE LT_SPLIT INDEX LW_INDEX. "delete keywork AS
    READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
    LS_TABLE_ALIAS-ALIAS = LW_STRING.
    DELETE LT_SPLIT INDEX LW_INDEX. "delete alias field
    APPEND LS_TABLE_ALIAS TO LT_TABLE_ALIAS.
  ENDDO.
* If no alias table found, create just an entry for "*"
  IF LT_TABLE_ALIAS[] IS INITIAL.
    READ TABLE LT_SPLIT INTO LW_STRING INDEX 1.
    LS_TABLE_ALIAS-TABLE = LW_STRING.
    LS_TABLE_ALIAS-ALIAS = '*'.
    APPEND LS_TABLE_ALIAS TO LT_TABLE_ALIAS.
  ENDIF.
  SORT LT_TABLE_ALIAS BY ALIAS.

* Write Data declaration
  C '***************************************'.              "#EC NOTEXT
  C '*      Begin of data declaration      *'.              "#EC NOTEXT
  C '*   Used to store lines of the query  *'.              "#EC NOTEXT
  C '***************************************'.              "#EC NOTEXT
  C 'DATA: BEGIN OF s_result'.                              "#EC NOTEXT
  LW_FIELD_NUMBER = 1.

  LW_STRING = LW_SELECT.
  IF FW_NEWSYNTAX = ABAP_TRUE.
    TRANSLATE LW_STRING USING ', '.
    CONDENSE LW_STRING.
  ENDIF.
  SPLIT LW_STRING AT SPACE INTO TABLE LT_SPLIT.

  LOOP AT LT_SPLIT INTO LW_STRING.
    LW_CURRENT_LINE = SY-TABIX.
    IF LW_STRING IS INITIAL OR LW_STRING CO SPACE.
      CONTINUE.
    ENDIF.
    IF LW_STRING = 'AS'.
      DELETE LT_SPLIT INDEX LW_CURRENT_LINE. "delete AS
      DELETE LT_SPLIT INDEX LW_CURRENT_LINE. "delete the alias name
      CONTINUE.
    ENDIF.
    LW_CURRENT_LENGTH = STRLEN( LW_STRING ).

    CLEAR LS_FIELDLIST.
    LS_FIELDLIST-REF_FIELD = LW_STRING.

* Manage new syntax "Case"
    IF FW_NEWSYNTAX = ABAP_TRUE AND LW_STRING = 'CASE'.
      LW_INDEX = LW_CURRENT_LINE.
      DO.
        LW_INDEX = LW_INDEX + 1.
        READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
        IF SY-SUBRC NE 0.
          MESSAGE 'Incorrect syntax in Case statement'(m62)
                   TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
          RETURN.
        ENDIF.
        IF LW_STRING = 'END'.
          LW_INDEX = LW_INDEX + 1.
          READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
          IF LW_STRING NE 'AS'.
            LW_INDEX = LW_INDEX - 1.
            CONTINUE.
          ENDIF.
          LW_INDEX = LW_INDEX + 1.
          READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.

          CLEAR LS_FIELDLIST.
          CONCATENATE 'F' LW_FIELD_NUMBER INTO LS_FIELDLIST-FIELD.
          CONCATENATE ',' LS_FIELDLIST-FIELD INTO LW_STRUCT_LINE.
          CONCATENATE LW_STRUCT_LINE 'TYPE string'          "#EC NOTEXT
                      INTO LW_STRUCT_LINE SEPARATED BY SPACE.
          C LW_STRUCT_LINE.
          LS_FIELDLIST-REF_TABLE = ''.
          LS_FIELDLIST-REF_FIELD = LW_STRING.
          APPEND LS_FIELDLIST TO FT_FIELDLIST.
          LW_FIELD_NUMBER = LW_FIELD_NUMBER + 1.

          LW_INDEX = LW_INDEX - LW_CURRENT_LINE + 1.
          DO LW_INDEX TIMES.
            DELETE LT_SPLIT INDEX LW_CURRENT_LINE. "delete the case element
          ENDDO.
          EXIT.
        ENDIF.
      ENDDO.
      CONTINUE.
    ENDIF.

* Manage "Count"
    IF LW_CURRENT_LENGTH GE 6.
      LW_CHAR_10 = LW_STRING(6).
    ELSE.
      CLEAR LW_CHAR_10.
    ENDIF.
    IF LW_CHAR_10 = 'COUNT('.
      CONCATENATE 'F' LW_FIELD_NUMBER INTO LS_FIELDLIST-FIELD.
      CONCATENATE ',' LS_FIELDLIST-FIELD INTO LW_STRUCT_LINE.

      LW_INDEX = LW_CURRENT_LINE + 1.
      DO.
        SEARCH LW_STRING FOR ')'.
        IF SY-SUBRC = 0.
          EXIT.
        ELSE.
* If there is space in the "count()", delete next lines
          READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
          IF SY-SUBRC NE 0.
            EXIT.
          ENDIF.
          CONCATENATE LS_FIELDLIST-REF_FIELD LW_STRING
                      INTO LS_FIELDLIST-REF_FIELD SEPARATED BY SPACE.
          DELETE LT_SPLIT INDEX LW_INDEX.
        ENDIF.
      ENDDO.
      CONCATENATE LW_STRUCT_LINE 'TYPE i'                   "#EC NOTEXT
                  INTO LW_STRUCT_LINE SEPARATED BY SPACE.
      C LW_STRUCT_LINE.
      APPEND LS_FIELDLIST TO FT_FIELDLIST.
      LW_FIELD_NUMBER = LW_FIELD_NUMBER + 1.
      CONTINUE.
    ENDIF.

* Manage Agregate AVG
    IF LW_CURRENT_LENGTH GE 4.
      LW_CHAR_10 = LW_STRING(4).
    ELSE.
      CLEAR LW_CHAR_10.
    ENDIF.
    IF LW_CHAR_10 = 'AVG('.
      CONCATENATE 'F' LW_FIELD_NUMBER INTO LS_FIELDLIST-FIELD.
      CONCATENATE ',' LS_FIELDLIST-FIELD INTO LW_STRUCT_LINE.

      LW_INDEX = LW_CURRENT_LINE + 1.
      DO.
        SEARCH LW_STRING FOR ')'.
        IF SY-SUBRC = 0.
          EXIT.
        ELSE.
* If there is space in the agregate, delete next lines
          READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
          IF SY-SUBRC NE 0.
            EXIT.
          ENDIF.
          CONCATENATE LS_FIELDLIST-REF_FIELD LW_STRING
                      INTO LS_FIELDLIST-REF_FIELD SEPARATED BY SPACE.
          DELETE LT_SPLIT INDEX LW_INDEX.
        ENDIF.
      ENDDO.
      CONCATENATE LW_STRUCT_LINE 'TYPE f'                   "#EC NOTEXT
                  INTO LW_STRUCT_LINE SEPARATED BY SPACE.
      C LW_STRUCT_LINE.
      APPEND LS_FIELDLIST TO FT_FIELDLIST.
      LW_FIELD_NUMBER = LW_FIELD_NUMBER + 1.
      CONTINUE.
    ENDIF.

* Manage agregate SUM, MAX, MIN
    IF LW_CURRENT_LENGTH GE 4.
      LW_CHAR_10 = LW_STRING(4).
    ELSE.
      CLEAR LW_CHAR_10.
    ENDIF.
    IF LW_CHAR_10 = 'SUM(' OR LW_CHAR_10 = 'MAX('
    OR LW_CHAR_10 = 'MIN('.
      CLEAR LW_STRING2.
      LW_INDEX = LW_CURRENT_LINE + 1.
      DO.
        SEARCH LW_STRING FOR ')'.
        IF SY-SUBRC = 0.
          EXIT.
        ELSE.
* Search name of the field in next lines.
          READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_INDEX.
          IF SY-SUBRC NE 0.
            EXIT.
          ENDIF.
          CONCATENATE LS_FIELDLIST-REF_FIELD LW_STRING
                      INTO LS_FIELDLIST-REF_FIELD SEPARATED BY SPACE.
          IF LW_STRING2 IS INITIAL.
            LW_STRING2 = LW_STRING.
          ENDIF.
* Delete lines of agregage in field table
          DELETE LT_SPLIT INDEX LW_INDEX.
        ENDIF.
      ENDDO.
      LW_STRING = LW_STRING2.
    ENDIF.

* Now lw_string contain a field name.
* We have to find the field description
    SPLIT LW_STRING AT '~' INTO LW_SELECT_TABLE LW_SELECT_FIELD.
    IF LW_SELECT_FIELD IS INITIAL.
      LW_SELECT_FIELD = LW_SELECT_TABLE.
      LW_SELECT_TABLE = '*'.
    ENDIF.
* Search if alias table used
    CLEAR LS_TABLE_ALIAS.
    READ TABLE LT_TABLE_ALIAS INTO LS_TABLE_ALIAS
               WITH KEY ALIAS = LW_SELECT_TABLE             "#EC WARNOK
               BINARY SEARCH.
    IF SY-SUBRC = 0.
      LW_SELECT_TABLE = LS_TABLE_ALIAS-TABLE.
    ENDIF.
    LS_FIELDLIST-REF_TABLE = LW_SELECT_TABLE.
    IF LW_STRING = '*' OR LW_SELECT_FIELD = '*'. " expansion table~*
      CLEAR LW_EXPLICIT.
      SELECT FIELDNAME POSITION
      INTO   (LW_DD03L_FIELDNAME,LW_POSITION_DUMMY)
      FROM   DD03L
      WHERE  TABNAME    = LW_SELECT_TABLE
      AND    FIELDNAME <> 'MANDT'
      AND    AS4LOCAL   = C_VERS_ACTIVE
      AND    AS4VERS    = SPACE
      AND (  COMPTYPE   = C_DDIC_DTELM
          OR COMPTYPE   = SPACE )
      ORDER BY POSITION.

        LW_SELECT_FIELD = LW_DD03L_FIELDNAME.

        CONCATENATE 'F' LW_FIELD_NUMBER INTO LS_FIELDLIST-FIELD.
        LS_FIELDLIST-REF_FIELD = LW_SELECT_FIELD.
        APPEND LS_FIELDLIST TO FT_FIELDLIST.
        CONCATENATE ',' LS_FIELDLIST-FIELD INTO LW_STRUCT_LINE.

        CONCATENATE LW_SELECT_TABLE '-' LW_SELECT_FIELD
                    INTO LW_STRUCT_LINE_TYPE.
        CONCATENATE LW_STRUCT_LINE 'TYPE' LW_STRUCT_LINE_TYPE
                    INTO LW_STRUCT_LINE
                    SEPARATED BY SPACE.
        C LW_STRUCT_LINE.
        LW_FIELD_NUMBER = LW_FIELD_NUMBER + 1.
* Explicit list of fields instead of *
* Generate longer query but mandatory in case of T1~* or MARA~*
* Required also in some special cases, for example if table use include
        IF LS_TABLE_ALIAS-ALIAS = SPACE OR LS_TABLE_ALIAS-ALIAS = '*'.
          CONCATENATE LW_EXPLICIT LW_SELECT_TABLE
                      INTO LW_EXPLICIT SEPARATED BY SPACE.
        ELSE.
          CONCATENATE LW_EXPLICIT LS_TABLE_ALIAS-ALIAS
                      INTO LW_EXPLICIT SEPARATED BY SPACE.
        ENDIF.
        CONCATENATE LW_EXPLICIT '~' LW_SELECT_FIELD INTO LW_EXPLICIT.
      ENDSELECT.
      IF SY-SUBRC NE 0.
        MESSAGE E701(1R) WITH LW_SELECT_TABLE. "table does not exist
      ENDIF.
      IF NOT LW_EXPLICIT IS INITIAL.
        REPLACE FIRST OCCURRENCE OF LW_STRING
                IN LW_SELECT WITH LW_EXPLICIT.
      ENDIF.

    ELSE. "Simple field
      CONCATENATE 'F' LW_FIELD_NUMBER INTO LS_FIELDLIST-FIELD.
      LS_FIELDLIST-REF_FIELD = LW_SELECT_FIELD.
      APPEND LS_FIELDLIST TO FT_FIELDLIST.

      CONCATENATE ',' LS_FIELDLIST-FIELD INTO LW_STRUCT_LINE.

      CONCATENATE LW_SELECT_TABLE '-' LW_SELECT_FIELD
                  INTO LW_STRUCT_LINE_TYPE.
      CONCATENATE LW_STRUCT_LINE 'TYPE' LW_STRUCT_LINE_TYPE
                  INTO LW_STRUCT_LINE
                  SEPARATED BY SPACE.
      C LW_STRUCT_LINE.
      LW_FIELD_NUMBER = LW_FIELD_NUMBER + 1.
    ENDIF.
  ENDLOOP.

  IF SY-UCOMM = 'SHOWCODE'.
    PERFORM FRM_GENERATE_PROGRAM TABLES LT_TABLE_ALIAS LT_SELECT_TABLE USING FW_WHERE   FT_FIELDLIST LW_QUERY.
    RETURN.
  ENDIF.

* Add a count field
  CLEAR LS_FIELDLIST.
  LS_FIELDLIST-FIELD = 'COUNT'.
  LS_FIELDLIST-REF_TABLE = ''.
  LS_FIELDLIST-REF_FIELD = 'Count'.                         "#EC NOTEXT
  APPEND LS_FIELDLIST TO FT_FIELDLIST.
  C ', COUNT type i'.                                       "#EC NOTEXT

* End of data definition
  C ', END OF s_result'.                                    "#EC NOTEXT
  C ', t_result like table of s_result'.                    "#EC NOTEXT
  C ', w_timestart type timestampl'.                        "#EC NOTEXT
  C ', w_timeend type timestampl.'.                         "#EC NOTEXT

* Write the dynamic subroutine that run the SELECT
  C 'FORM run_sql CHANGING fo_result TYPE REF TO data'.     "#EC NOTEXT
  C '                      fw_time type p'.                 "#EC NOTEXT
  C '                      fw_count type i.'.               "#EC NOTEXT
  C 'field-symbols <fs_result> like s_result.'.             "#EC NOTEXT
  C '***************************************'.              "#EC NOTEXT
  C '*            Begin of query           *'.              "#EC NOTEXT
  C '***************************************'.              "#EC NOTEXT
  C 'get TIME STAMP FIELD w_timestart.'.                    "#EC NOTEXT
  IF FW_COUNT = ABAP_TRUE.
    CONCATENATE 'SELECT SINGLE' LW_SELECT                   "#EC NOTEXT
                INTO LW_SELECT SEPARATED BY SPACE.
    C LW_SELECT.
    IF FW_NEWSYNTAX = ABAP_TRUE.
      C 'INTO @s_result-f000001'.                           "#EC NOTEXT
    ELSE.
      C 'INTO s_result-f000001'.                            "#EC NOTEXT
    ENDIF.
  ELSE.
    IF LW_SELECT_DISTINCT NE SPACE.
      CONCATENATE 'SELECT DISTINCT' LW_SELECT               "#EC NOTEXT
                  INTO LW_SELECT SEPARATED BY SPACE.
    ELSE.
      CONCATENATE 'SELECT' LW_SELECT                        "#EC NOTEXT
                  INTO LW_SELECT SEPARATED BY SPACE.
    ENDIF.
    C LW_SELECT.
    IF FW_NEWSYNTAX = ABAP_TRUE.
      C 'INTO TABLE @t_result'.                             "#EC NOTEXT
    ELSE.
      C 'INTO TABLE t_result'.                              "#EC NOTEXT
    ENDIF.

* Add UP TO xxx ROWS
    IF NOT FW_ROWS IS INITIAL.
      C 'UP TO'.                                            "#EC NOTEXT
      C FW_ROWS.
      C 'ROWS'.                                             "#EC NOTEXT
    ENDIF.
  ENDIF.

  C 'FROM'.                                                 "#EC NOTEXT
  C LW_FROM.

* Where, group by, having, order by
  IF NOT FW_WHERE IS INITIAL.
    C FW_WHERE.
  ENDIF.
  C '.'.

* Display query execution time
  C 'get TIME STAMP FIELD w_timeend.'.                      "#EC NOTEXT
  C 'fw_time = w_timeend - w_timestart.'.                   "#EC NOTEXT
  C 'fw_count = sy-dbcnt.'.                                 "#EC NOTEXT

* If select count( * ), display number of results
  IF FW_COUNT NE SPACE.
    C 'MESSAGE i753(TG) WITH s_result-f000001.'.            "#EC NOTEXT
  ENDIF.
  C 'loop at t_result assigning <fs_result>.'.              "#EC NOTEXT
  C ' <fs_result>-count = 1.'.                              "#EC NOTEXT
  C 'endloop.'.                                             "#EC NOTEXT
  C 'GET REFERENCE OF t_result INTO fo_result.'.            "#EC NOTEXT
  C 'ENDFORM.'.                                             "#EC NOTEXT
  CLEAR : LW_LINE,
          LW_WORD,
          LW_MESS.
  SYNTAX-CHECK FOR LT_CODE_STRING PROGRAM SY-REPID
               MESSAGE LW_MESS LINE LW_LINE WORD LW_WORD.
  IF SY-SUBRC NE 0 AND FW_DISPLAY = SPACE.
    MESSAGE LW_MESS TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
    CLEAR FW_PROGRAM.
    RETURN.
  ENDIF.

  IF FW_DISPLAY = SPACE.
    GENERATE SUBROUTINE POOL LT_CODE_STRING NAME FW_PROGRAM.
  ELSE.
    IF LW_MESS IS NOT INITIAL.
      LW_EXPLICIT = LW_LINE.
      CONCATENATE LW_MESS '(line'(m28) LW_EXPLICIT ',word'(m29)
                  LW_WORD ')'(m30)
                  INTO LW_MESS SEPARATED BY SPACE.
      MESSAGE LW_MESS TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
    ENDIF.
    EDITOR-CALL FOR LT_CODE_STRING DISPLAY-MODE
                TITLE 'Generated code for current query'(t01).
  ENDIF.

ENDFORM.                    " QUERY_GENERATE

*&---------------------------------------------------------------------*
*&      Form  RESULT_DISPLAY
*&---------------------------------------------------------------------*
*       Display data table in the bottom ALV part of the screen
*----------------------------------------------------------------------*
*      -->FO_RESULT    Reference to data to display
*      -->FT_FIELDLIST List of fields to display
*      -->FW_TITLE     Title of the ALV
*----------------------------------------------------------------------*
FORM RESULT_DISPLAY  USING FO_RESULT TYPE REF TO DATA
                           FT_FIELDLIST TYPE TY_FIELDLIST_TABLE
                           FW_TITLE TYPE STRING.
*  TYPE-POOLS lvc. "for older sap system only

  DATA : LS_LAYOUT    TYPE LVC_S_LAYO,
         LT_FIELDCAT  TYPE LVC_T_FCAT,
         LS_FIELDLIST TYPE TY_FIELDLIST,
         LS_FIELDCAT  LIKE LINE OF LT_FIELDCAT.
  DATA : LO_DESCR_TABLE TYPE REF TO CL_ABAP_TABLEDESCR,
         LO_DESCR_LINE  TYPE REF TO CL_ABAP_STRUCTDESCR,
         LS_COMPX       TYPE ABAP_COMPDESCR,
         LW_HEIGHT      TYPE I.

  FIELD-SYMBOLS: <LFT_DATA> TYPE ANY TABLE.

  ASSIGN FO_RESULT->* TO <LFT_DATA>.

* Get data type for COUNT & AVG fields
  LO_DESCR_TABLE ?=
    CL_ABAP_TYPEDESCR=>DESCRIBE_BY_DATA_REF( FO_RESULT ).
  LO_DESCR_LINE ?= LO_DESCR_TABLE->GET_TABLE_LINE_TYPE( ).

  LOOP AT FT_FIELDLIST INTO LS_FIELDLIST.
    CLEAR LS_FIELDCAT.
    LS_FIELDCAT-FIELDNAME = LS_FIELDLIST-FIELD.

    IF NOT LS_FIELDLIST-REF_TABLE IS INITIAL.
      LS_FIELDCAT-REF_FIELD = LS_FIELDLIST-REF_FIELD.
      LS_FIELDCAT-REF_TABLE = LS_FIELDLIST-REF_TABLE.
      IF S_CUSTOMIZE-TECHNAME = SPACE.
        LS_FIELDCAT-REPTEXT = LS_FIELDLIST-REF_FIELD.
      ELSE.
        LS_FIELDCAT-REPTEXT = LS_FIELDLIST-REF_FIELD.
        LS_FIELDCAT-SCRTEXT_S = LS_FIELDLIST-REF_FIELD.
        LS_FIELDCAT-SCRTEXT_M = LS_FIELDLIST-REF_FIELD.
        LS_FIELDCAT-SCRTEXT_L = LS_FIELDLIST-REF_FIELD.
      ENDIF.
    ELSE. "COUNT & AVG field
      CLEAR LS_COMPX.
      READ TABLE LO_DESCR_LINE->COMPONENTS INTO LS_COMPX
                 WITH KEY NAME = LS_FIELDLIST-FIELD.        "#EC WARNOK
      LS_FIELDCAT-INTLEN = LS_COMPX-LENGTH.
      LS_FIELDCAT-DECIMALS = LS_COMPX-DECIMALS.
      LS_FIELDCAT-INTTYPE = LS_COMPX-TYPE_KIND.
      LS_FIELDCAT-REPTEXT = LS_FIELDLIST-REF_FIELD.
      LS_FIELDCAT-SCRTEXT_S = LS_FIELDLIST-REF_FIELD.
      LS_FIELDCAT-SCRTEXT_M = LS_FIELDLIST-REF_FIELD.
      LS_FIELDCAT-SCRTEXT_L = LS_FIELDLIST-REF_FIELD.
    ENDIF.
    APPEND LS_FIELDCAT TO LT_FIELDCAT.
  ENDLOOP.

  LS_LAYOUT-SMALLTITLE = ABAP_TRUE.
  LS_LAYOUT-ZEBRA = ABAP_TRUE.
  LS_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  LS_LAYOUT-GRID_TITLE = FW_TITLE.
  LS_LAYOUT-COUNTFNAME = 'COUNT'.

* Set the grid config and content
  CALL METHOD S_TAB_ACTIVE-O_ALV_RESULT->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
      IS_LAYOUT       = LS_LAYOUT
    CHANGING
      IT_OUTTAB       = <LFT_DATA>
      IT_FIELDCATALOG = LT_FIELDCAT.

* Search if grid is currently displayed
  CALL METHOD O_SPLITTER->GET_ROW_HEIGHT
    EXPORTING
      ID     = 1
    IMPORTING
      RESULT = LW_HEIGHT.
  CALL METHOD CL_GUI_CFW=>FLUSH.

* If grid is hidden, display it
  IF LW_HEIGHT = 100.
    CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
      EXPORTING
        ID     = 1
        HEIGHT = 20.
  ENDIF.
ENDFORM.                    " RESULT_DISPLAY

*&---------------------------------------------------------------------*
*&      Form  DDIC_INIT
*&---------------------------------------------------------------------*
*       Initialize ddic tree
*----------------------------------------------------------------------*
FORM DDIC_INIT.
  DATA : LS_HEADER   TYPE TREEV_HHDR,
         LS_EVENT    TYPE CNTL_SIMPLE_EVENT,
         LT_EVENTS   TYPE CNTL_SIMPLE_EVENTS,
         LO_DRAGDROP TYPE REF TO CL_DRAGDROP,
         LW_MODE     TYPE I.

  LS_HEADER-HEADING = 'SAP Table/Fields'(t02).
  LS_HEADER-WIDTH = 30.
  LW_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_SINGLE.

  CREATE OBJECT S_TAB_ACTIVE-O_TREE_DDIC
    EXPORTING
      PARENT                      = O_CONTAINER_DDIC
      NODE_SELECTION_MODE         = LW_MODE
      ITEM_SELECTION              = ABAP_TRUE
      HIERARCHY_COLUMN_NAME       = C_DDIC_COL1
      HIERARCHY_HEADER            = LS_HEADER
    EXCEPTIONS
      CNTL_SYSTEM_ERROR           = 1
      CREATE_ERROR                = 2
      FAILED                      = 3
      ILLEGAL_NODE_SELECTION_MODE = 4
      ILLEGAL_COLUMN_NAME         = 5
      LIFETIME_ERROR              = 6.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

* Column2
  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->ADD_COLUMN
    EXPORTING
      NAME                         = C_DDIC_COL2
      WIDTH                        = 21
      HEADER_TEXT                  = 'Description'(t03)
    EXCEPTIONS
      COLUMN_EXISTS                = 1
      ILLEGAL_COLUMN_NAME          = 2
      TOO_MANY_COLUMNS             = 3
      ILLEGAL_ALIGNMENT            = 4
      DIFFERENT_COLUMN_TYPES       = 5
      CNTL_SYSTEM_ERROR            = 6
      FAILED                       = 7
      PREDECESSOR_COLUMN_NOT_FOUND = 8.

* Manage Item clic event to copy value in clipboard
  LS_EVENT-EVENTID = CL_GUI_COLUMN_TREE=>EVENTID_ITEM_DOUBLE_CLICK.
  LS_EVENT-APPL_EVENT = ABAP_TRUE.
  APPEND LS_EVENT TO LT_EVENTS.

  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS                    = LT_EVENTS
    EXCEPTIONS
      CNTL_ERROR                = 1
      CNTL_SYSTEM_ERROR         = 2
      ILLEGAL_EVENT_COMBINATION = 3.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

* Manage Drag from DDIC editor
  CREATE OBJECT LO_DRAGDROP.
  CALL METHOD LO_DRAGDROP->ADD
    EXPORTING
      FLAVOR     = 'EDIT_INSERT'
      DRAGSRC    = ABAP_TRUE
      DROPTARGET = SPACE
      EFFECT     = CL_DRAGDROP=>COPY.
  CALL METHOD LO_DRAGDROP->GET_HANDLE
    IMPORTING
      HANDLE = W_DRAGDROP_HANDLE_TREE.

  SET HANDLER O_HANDLE_EVENT->HND_DDIC_ITEM_DBLCLICK FOR S_TAB_ACTIVE-O_TREE_DDIC.
  SET HANDLER O_HANDLE_EVENT->HND_DDIC_DRAG FOR S_TAB_ACTIVE-O_TREE_DDIC.

* Calculate ZSPRO nodes to add at the bottom of the ddic tree
  PERFORM DDIC_ADD_TREE_ZSPRO IN PROGRAM (SY-REPID) IF FOUND.

ENDFORM.                    " DDIC_INIT

*&---------------------------------------------------------------------*
*&      Form  DDIC_SET_TREE
*&---------------------------------------------------------------------*
*       Refresh query with list of table/fields of the given query
*       Add User defined tree from ZSPRO (if relevant)
*----------------------------------------------------------------------*
*      -->FW_FROM  From part of the query
*----------------------------------------------------------------------*
FORM DDIC_SET_TREE USING FW_FROM TYPE STRING.

  DATA : LW_FROM   TYPE STRING,
         LT_SPLIT  TYPE TABLE OF STRING,
         LW_STRING TYPE STRING,
         LW_TABIX  TYPE I,
         BEGIN OF LS_TABLE_LIST,
           TABLE(30),
           ALIAS(30),
         END OF LS_TABLE_LIST,
         LT_TABLE_LIST     LIKE TABLE OF LS_TABLE_LIST,
         LW_NODE_NUMBER(6) TYPE N,
         LS_NODE           LIKE LINE OF S_TAB_ACTIVE-T_NODE_DDIC,
         LS_ITEM           LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LW_PARENT_NODE    LIKE LS_NODE-NODE_KEY,
         BEGIN OF LS_DDIC_FIELDS,
           TABNAME   TYPE DD03L-TABNAME,
           FIELDNAME TYPE DD03L-FIELDNAME,
           POSITION  TYPE DD03L-POSITION,
           KEYFLAG   TYPE DD03L-KEYFLAG,
           DDTEXT1   TYPE DD03T-DDTEXT,
           DDTEXT2   TYPE DD04T-DDTEXT,
         END OF LS_DDIC_FIELDS,
         LT_DDIC_FIELDS LIKE TABLE OF LS_DDIC_FIELDS.

  CONCATENATE 'FROM' FW_FROM INTO LW_FROM SEPARATED BY SPACE.

  TRANSLATE LW_FROM TO UPPER CASE.

  SPLIT LW_FROM AT SPACE INTO TABLE LT_SPLIT.
  LOOP AT LT_SPLIT INTO LW_STRING.
    LW_TABIX = SY-TABIX + 1.
    CHECK SY-TABIX = 1 OR LW_STRING = 'JOIN'.
* Read next line (table name)
    READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_TABIX.
    CHECK SY-SUBRC = 0.

    CLEAR LS_TABLE_LIST.
    LS_TABLE_LIST-TABLE = LW_STRING.

    LW_TABIX = LW_TABIX + 1.
* Read next line (search alias)
    READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_TABIX.
    IF SY-SUBRC = 0 AND LW_STRING = 'AS'.
      LW_TABIX = LW_TABIX + 1.
      READ TABLE LT_SPLIT INTO LW_STRING INDEX LW_TABIX.
      IF SY-SUBRC = 0.
        LS_TABLE_LIST-ALIAS = LW_STRING.
      ENDIF.
    ENDIF.
    APPEND LS_TABLE_LIST TO LT_TABLE_LIST.
  ENDLOOP.

* Get list of fields for selected tables
  IF NOT LT_TABLE_LIST IS INITIAL.
    SELECT DD03L~TABNAME DD03L~FIELDNAME DD03L~POSITION
           DD03L~KEYFLAG DD03T~DDTEXT DD04T~DDTEXT
           INTO TABLE LT_DDIC_FIELDS
           FROM DD03L
           LEFT OUTER JOIN DD03T
           ON DD03L~TABNAME = DD03T~TABNAME
           AND DD03L~FIELDNAME = DD03T~FIELDNAME
           AND DD03L~AS4LOCAL = DD03T~AS4LOCAL
           AND DD03T~DDLANGUAGE = SY-LANGU
           LEFT OUTER JOIN DD04T
           ON DD03L~ROLLNAME = DD04T~ROLLNAME
           AND DD03L~AS4LOCAL = DD04T~AS4LOCAL
           AND DD04T~DDLANGUAGE = SY-LANGU
           FOR ALL ENTRIES IN LT_TABLE_LIST
           WHERE DD03L~TABNAME = LT_TABLE_LIST-TABLE
           AND DD03L~AS4LOCAL = C_VERS_ACTIVE
           AND DD03L~AS4VERS = SPACE
           AND ( DD03L~COMPTYPE = C_DDIC_DTELM
           OR    DD03L~COMPTYPE = SPACE ).
    SORT LT_DDIC_FIELDS BY TABNAME KEYFLAG DESCENDING POSITION.
    DELETE ADJACENT DUPLICATES FROM LT_DDIC_FIELDS
                               COMPARING TABNAME FIELDNAME.
  ENDIF.

* Build Node & Item tree
  REFRESH : S_TAB_ACTIVE-T_NODE_DDIC,
            S_TAB_ACTIVE-T_ITEM_DDIC.
  LW_NODE_NUMBER = 0.
  LOOP AT LT_TABLE_LIST INTO LS_TABLE_LIST.
* Check table exists (has at least one field)
    READ TABLE LT_DDIC_FIELDS TRANSPORTING NO FIELDS
               WITH KEY TABNAME = LS_TABLE_LIST-TABLE.
    IF SY-SUBRC NE 0.
      DELETE LT_TABLE_LIST.
      CONTINUE.
    ENDIF.

    LW_NODE_NUMBER = LW_NODE_NUMBER + 1.
    CLEAR LS_NODE.
    LS_NODE-NODE_KEY = LW_NODE_NUMBER.
    LS_NODE-ISFOLDER = ABAP_TRUE.
    LS_NODE-N_IMAGE = '@PO@'.
    LS_NODE-EXP_IMAGE = '@PO@'.
    LS_NODE-EXPANDER = ABAP_TRUE.
    APPEND LS_NODE TO S_TAB_ACTIVE-T_NODE_DDIC.

    CLEAR LS_ITEM.
    LS_ITEM-NODE_KEY = LW_NODE_NUMBER.
    LS_ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_TEXT.
    LS_ITEM-ITEM_NAME = C_DDIC_COL1.
    IF LS_TABLE_LIST-ALIAS IS INITIAL.
      LS_ITEM-TEXT = LS_TABLE_LIST-TABLE.
    ELSE.
      CONCATENATE LS_TABLE_LIST-TABLE 'AS' LS_TABLE_LIST-ALIAS
                   INTO LS_ITEM-TEXT SEPARATED BY SPACE.
    ENDIF.
    APPEND LS_ITEM TO S_TAB_ACTIVE-T_ITEM_DDIC.
    LS_ITEM-ITEM_NAME = C_DDIC_COL2.
    SELECT SINGLE DDTEXT INTO LS_ITEM-TEXT
           FROM DD02T
           WHERE TABNAME = LS_TABLE_LIST-TABLE
           AND DDLANGUAGE = SY-LANGU
           AND AS4LOCAL = C_VERS_ACTIVE
           AND AS4VERS = SPACE.
    IF SY-SUBRC NE 0.
      LS_ITEM-TEXT = LS_TABLE_LIST-TABLE.
    ENDIF.
    APPEND LS_ITEM TO S_TAB_ACTIVE-T_ITEM_DDIC.

* Display list of fields
    LW_PARENT_NODE = LS_NODE-NODE_KEY.
    LOOP AT LT_DDIC_FIELDS INTO LS_DDIC_FIELDS
            WHERE TABNAME = LS_TABLE_LIST-TABLE.
      CLEAR LS_NODE.
      LW_NODE_NUMBER = LW_NODE_NUMBER + 1.
      LS_NODE-NODE_KEY = LW_NODE_NUMBER.
      LS_NODE-RELATKEY = LW_PARENT_NODE.
      LS_NODE-RELATSHIP = CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD.
      IF LS_DDIC_FIELDS-KEYFLAG = SPACE.
        LS_NODE-N_IMAGE = '@3W@'.
        LS_NODE-EXP_IMAGE = '@3W@'.
      ELSE.
        LS_NODE-N_IMAGE = '@3V@'.
        LS_NODE-EXP_IMAGE = '@3V@'.
      ENDIF.
      LS_NODE-DRAGDROPID = W_DRAGDROP_HANDLE_TREE.
      APPEND LS_NODE TO S_TAB_ACTIVE-T_NODE_DDIC.

      CLEAR LS_ITEM.
      LS_ITEM-NODE_KEY = LW_NODE_NUMBER.
      LS_ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_TEXT.
      LS_ITEM-ITEM_NAME = C_DDIC_COL1.
      LS_ITEM-TEXT = LS_DDIC_FIELDS-FIELDNAME.
      APPEND LS_ITEM TO S_TAB_ACTIVE-T_ITEM_DDIC.
      LS_ITEM-ITEM_NAME = C_DDIC_COL2.
      IF NOT LS_DDIC_FIELDS-DDTEXT1 IS INITIAL.
        LS_ITEM-TEXT = LS_DDIC_FIELDS-DDTEXT1.
      ELSE.
        LS_ITEM-TEXT = LS_DDIC_FIELDS-DDTEXT2.
      ENDIF.
      APPEND LS_ITEM TO S_TAB_ACTIVE-T_ITEM_DDIC.
    ENDLOOP.
  ENDLOOP.

* Add User defined tree from ZSPRO (if relevant)
  IF NOT T_NODE_ZSPRO IS INITIAL.
    APPEND LINES OF T_NODE_ZSPRO TO S_TAB_ACTIVE-T_NODE_DDIC.
    APPEND LINES OF T_ITEM_ZSPRO TO S_TAB_ACTIVE-T_ITEM_DDIC.
  ENDIF.

  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->DELETE_ALL_NODES.

  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->ADD_NODES_AND_ITEMS
    EXPORTING
      NODE_TABLE                     = S_TAB_ACTIVE-T_NODE_DDIC
      ITEM_TABLE                     = S_TAB_ACTIVE-T_ITEM_DDIC
      ITEM_TABLE_STRUCTURE_NAME      = 'MTREEITM'
    EXCEPTIONS
      FAILED                         = 1
      CNTL_SYSTEM_ERROR              = 3
      ERROR_IN_TABLES                = 4
      DP_ERROR                       = 5
      TABLE_STRUCTURE_NAME_NOT_FOUND = 6.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

  DESCRIBE TABLE LT_TABLE_LIST LINES LW_TABIX.

* If no table found, display message
  IF LW_TABIX = 0.
    MESSAGE 'No valid table found'(m15) TYPE C_MSG_SUCCESS
            DISPLAY LIKE C_MSG_ERROR.
* If 1 table found, expand it
  ELSEIF LW_TABIX = 1.
    S_TAB_ACTIVE-O_TREE_DDIC->EXPAND_ROOT_NODES( ).
  ENDIF.
ENDFORM.                    " DDIC_SET_TREE

*&---------------------------------------------------------------------*
*&      Form  REPO_SAVE_QUERY
*&---------------------------------------------------------------------*
*       Save query
*----------------------------------------------------------------------*
FORM REPO_SAVE_QUERY.
  DATA : LT_QUERY         TYPE SOLI_TAB,
         LS_QUERY         LIKE LINE OF LT_QUERY,
         LW_QUERY_WITH_CR TYPE STRING,
         LW_GUID          TYPE GUID_32,
         LS_ZTOAD         TYPE ZTOAD,
         LW_TIMESTAMP(14) TYPE C.

* Set default options
  SELECT SINGLE CLASS INTO S_OPTIONS-VISIBILITYGRP
         FROM USR02
         WHERE BNAME = SY-UNAME.
  S_OPTIONS-VISIBILITY = '0'.

* Ask for options / query name
  CALL SCREEN 0200 STARTING AT 10 5
                   ENDING AT 60 7.
  IF S_OPTIONS IS INITIAL.
    MESSAGE 'Action cancelled'(m14) TYPE C_MSG_SUCCESS
            DISPLAY LIKE C_MSG_ERROR.
    RETURN.
  ENDIF.

* Get content of abap edit box
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXT
    IMPORTING
      TABLE  = LT_QUERY[]
    EXCEPTIONS
      OTHERS = 1.

* Serialize query into a string
  CLEAR LW_QUERY_WITH_CR.
  LOOP AT LT_QUERY INTO LS_QUERY.
    CONCATENATE LW_QUERY_WITH_CR LS_QUERY CL_ABAP_CHAR_UTILITIES=>CR_LF
                INTO LW_QUERY_WITH_CR.
  ENDLOOP.

* Generate new GUID
  DO 100 TIMES.
* Old function to get an unique id
    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        EV_GUID_32 = LW_GUID.
* New function to get an unique id (do not work on older sap system)
*    TRY.
*        lw_guid = cl_system_uuid=>create_uuid_c32_static( ).
*      CATCH cx_uuid_error.
*        EXIT. "exit do
*    ENDTRY.

* Check that this uid is not already used
    SELECT SINGLE QUERYID INTO LS_ZTOAD-QUERYID
           FROM ZTOAD
           WHERE QUERYID = LW_GUID.
    IF SY-SUBRC NE 0.
      EXIT. "exit do
    ENDIF.
  ENDDO.

  LS_ZTOAD-QUERYID = LW_GUID.
  LS_ZTOAD-OWNER = SY-UNAME.
  LW_TIMESTAMP(8) = SY-DATUM.
  LW_TIMESTAMP+8 = SY-UZEIT.
  LS_ZTOAD-AEDAT = LW_TIMESTAMP.
  LS_ZTOAD-TEXT = S_OPTIONS-NAME.
  LS_ZTOAD-VISIBILITY = S_OPTIONS-VISIBILITY.
  LS_ZTOAD-VISIBILITY_GROUP = S_OPTIONS-VISIBILITYGRP.
  LS_ZTOAD-QUERY = LW_QUERY_WITH_CR.
  INSERT ZTOAD FROM LS_ZTOAD.
  IF SY-SUBRC = 0.
    MESSAGE S031(R9). "Query saved
  ELSE.
    MESSAGE E220(IQAPI). "Error when saving the query
  ENDIF.

* Reset the modified status
  S_TAB_ACTIVE-O_TEXTEDIT->SET_TEXTMODIFIED_STATUS( ).

* Refresh repository to display new saved query
  PERFORM REPO_FILL.

* Focus repository on new saved query
  PERFORM REPO_FOCUS_QUERY USING LW_GUID.
ENDFORM.                    " REPO_SAVE_QUERY

*&---------------------------------------------------------------------*
*&      Form  REPO_INIT
*&---------------------------------------------------------------------*
*       Initialize repository tree
*----------------------------------------------------------------------*
FORM REPO_INIT.
  DATA: LT_EVENT TYPE CNTL_SIMPLE_EVENTS,
        LS_EVENT TYPE CNTL_SIMPLE_EVENT.

* Create a tree control
  CREATE OBJECT O_TREE_REPOSITORY
    EXPORTING
      PARENT              = O_CONTAINER_REPOSITORY
      NODE_SELECTION_MODE = CL_GUI_SIMPLE_TREE=>NODE_SEL_MODE_SINGLE
    EXCEPTIONS
      LIFETIME_ERROR      = 1
      CNTL_SYSTEM_ERROR   = 2
      CREATE_ERROR        = 3
      FAILED              = 4
      OTHERS              = 5.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

* Catch double clic to open query
  LS_EVENT-EVENTID = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  LS_EVENT-APPL_EVENT = ABAP_TRUE. " no PAI if event occurs
  APPEND LS_EVENT TO LT_EVENT.

* Catch context menu call
  LS_EVENT-EVENTID = CL_GUI_SIMPLE_TREE=>EVENTID_NODE_CONTEXT_MENU_REQ.
  LS_EVENT-APPL_EVENT = ABAP_TRUE. " no PAI if event occurs
  APPEND LS_EVENT TO LT_EVENT.

  CALL METHOD O_TREE_REPOSITORY->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS                    = LT_EVENT
    EXCEPTIONS
      CNTL_ERROR                = 1
      CNTL_SYSTEM_ERROR         = 2
      ILLEGAL_EVENT_COMBINATION = 3.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

* Assign event handlers in the application class to each desired event
  SET HANDLER O_HANDLE_EVENT->HND_REPO_DBLCLICK
      FOR O_TREE_REPOSITORY.
  SET HANDLER O_HANDLE_EVENT->HND_REPO_CONTEXT_MENU
      FOR O_TREE_REPOSITORY.
  SET HANDLER O_HANDLE_EVENT->HND_REPO_CONTEXT_MENU_SEL
      FOR O_TREE_REPOSITORY.

  PERFORM REPO_FILL.

ENDFORM.                    " REPO_INIT

*&---------------------------------------------------------------------*
*&      Form  REPO_FILL
*&---------------------------------------------------------------------*
*       Fill repository tree with all allowed queries
*----------------------------------------------------------------------*
FORM REPO_FILL.
  DATA : LW_USERGROUP TYPE USR02-CLASS,
         BEGIN OF LS_QUERY,
           QUERYID    TYPE ZTOAD-QUERYID,
           AEDAT      TYPE ZTOAD-AEDAT,
           VISIBILITY TYPE ZTOAD-VISIBILITY,
           TEXT       TYPE ZTOAD-TEXT,
           QUERY      TYPE ZTOAD-QUERY,
         END OF LS_QUERY,
         LT_QUERY_MY     LIKE TABLE OF LS_QUERY,
         LT_QUERY_SHARED LIKE TABLE OF LS_QUERY,
         LW_NODE_KEY(6)  TYPE N,
         LW_QUERYID      TYPE ZTOAD-QUERYID,
         LW_DUMMY(1)     TYPE C.                            "#EC NEEDED

* Get usergroup
  SELECT SINGLE CLASS INTO LW_USERGROUP
         FROM USR02
         WHERE BNAME = SY-UNAME.

* Get all my queries
  SELECT QUERYID AEDAT VISIBILITY TEXT QUERY INTO TABLE LT_QUERY_MY
         FROM ZTOAD
         WHERE OWNER = SY-UNAME.

* Get all queries that i can use
  SELECT QUERYID AEDAT VISIBILITY TEXT INTO TABLE LT_QUERY_SHARED
         FROM ZTOAD
         WHERE OWNER NE SY-UNAME
         AND ( VISIBILITY = C_VISIBILITY_ALL
               OR ( VISIBILITY = C_VISIBILITY_SHARED
                    AND VISIBILITY_GROUP = LW_USERGROUP )
             ).
  REFRESH T_NODE_REPOSITORY.

  CALL METHOD O_TREE_REPOSITORY->DELETE_ALL_NODES.

  CLEAR S_NODE_REPOSITORY.
  S_NODE_REPOSITORY-NODE_KEY = C_NODEKEY_REPO_MY.
  S_NODE_REPOSITORY-ISFOLDER = ABAP_TRUE.
  S_NODE_REPOSITORY-TEXT = 'My queries'(m16).
  APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.

  CLEAR LW_NODE_KEY.
  CONCATENATE SY-UNAME '+++' INTO LW_QUERYID.
  LOOP AT LT_QUERY_MY INTO LS_QUERY WHERE QUERYID NP LW_QUERYID.
    LW_NODE_KEY = LW_NODE_KEY + 1.
    CLEAR S_NODE_REPOSITORY.
    S_NODE_REPOSITORY-NODE_KEY = LW_NODE_KEY.
    S_NODE_REPOSITORY-RELATKEY = C_NODEKEY_REPO_MY.
    S_NODE_REPOSITORY-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
    IF LS_QUERY-VISIBILITY = C_VISIBILITY_MY.
      S_NODE_REPOSITORY-N_IMAGE = S_NODE_REPOSITORY-EXP_IMAGE = '@LC@'.
    ELSE.
      S_NODE_REPOSITORY-N_IMAGE = S_NODE_REPOSITORY-EXP_IMAGE = '@L9@'.
    ENDIF.
    S_NODE_REPOSITORY-TEXT = LS_QUERY-TEXT.
    S_NODE_REPOSITORY-QUERYID = LS_QUERY-QUERYID.
    S_NODE_REPOSITORY-EDIT = ABAP_TRUE.
    APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.
  ENDLOOP.

  CLEAR S_NODE_REPOSITORY.
  S_NODE_REPOSITORY-NODE_KEY = C_NODEKEY_REPO_SHARED.
  S_NODE_REPOSITORY-ISFOLDER = ABAP_TRUE.
  S_NODE_REPOSITORY-TEXT = 'Shared queries'(m17).
  APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.

  LOOP AT LT_QUERY_SHARED INTO LS_QUERY.
    LW_NODE_KEY = LW_NODE_KEY + 1.
    CLEAR S_NODE_REPOSITORY.
    S_NODE_REPOSITORY-NODE_KEY = LW_NODE_KEY.
    S_NODE_REPOSITORY-RELATKEY = C_NODEKEY_REPO_SHARED.
    S_NODE_REPOSITORY-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
    S_NODE_REPOSITORY-N_IMAGE = S_NODE_REPOSITORY-EXP_IMAGE = '@L9@'.
    S_NODE_REPOSITORY-TEXT = LS_QUERY-TEXT.
    S_NODE_REPOSITORY-QUERYID = LS_QUERY-QUERYID.
    S_NODE_REPOSITORY-EDIT = SPACE.
    APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.
  ENDLOOP.

* Add history node
  CLEAR S_NODE_REPOSITORY.
  S_NODE_REPOSITORY-NODE_KEY = C_NODEKEY_REPO_HISTORY.
  S_NODE_REPOSITORY-ISFOLDER = ABAP_TRUE.
  S_NODE_REPOSITORY-TEXT = 'History'(m18).
  APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.

  DELETE LT_QUERY_MY WHERE QUERYID NP LW_QUERYID.
  SORT LT_QUERY_MY BY AEDAT DESCENDING.
  LOOP AT LT_QUERY_MY INTO LS_QUERY.
    LW_NODE_KEY = LW_NODE_KEY + 1.
    CLEAR S_NODE_REPOSITORY.
    S_NODE_REPOSITORY-NODE_KEY = LW_NODE_KEY.
    S_NODE_REPOSITORY-RELATKEY = C_NODEKEY_REPO_HISTORY.
    S_NODE_REPOSITORY-RELATSHIP = CL_GUI_SIMPLE_TREE=>RELAT_LAST_CHILD.
    S_NODE_REPOSITORY-N_IMAGE = S_NODE_REPOSITORY-EXP_IMAGE = '@LC@'.
    S_NODE_REPOSITORY-TEXT = LS_QUERY-TEXT.
    S_NODE_REPOSITORY-QUERYID = LS_QUERY-QUERYID.
    S_NODE_REPOSITORY-EDIT = ABAP_TRUE.
    IF LS_QUERY-QUERY(1) = '*'.
      SPLIT LS_QUERY-QUERY+1 AT CL_ABAP_CHAR_UTILITIES=>CR_LF
            INTO LS_QUERY-QUERY LW_DUMMY.
      CONCATENATE S_NODE_REPOSITORY-TEXT ':' LS_QUERY-QUERY
                  INTO S_NODE_REPOSITORY-TEXT SEPARATED BY SPACE.
    ENDIF.
    APPEND S_NODE_REPOSITORY TO T_NODE_REPOSITORY.
  ENDLOOP.

  CALL METHOD O_TREE_REPOSITORY->ADD_NODES
    EXPORTING
      TABLE_STRUCTURE_NAME           = 'MTREESNODE'
      NODE_TABLE                     = T_NODE_REPOSITORY
    EXCEPTIONS
      FAILED                         = 1
      ERROR_IN_NODE_TABLE            = 2
      DP_ERROR                       = 3
      TABLE_STRUCTURE_NAME_NOT_FOUND = 4
      OTHERS                         = 5.
  IF SY-SUBRC <> 0.
    MESSAGE A000(TREE_CONTROL_MSG).
  ENDIF.

* Exand all root nodes (my, shared, history)
  CALL METHOD O_TREE_REPOSITORY->EXPAND_ROOT_NODES.
ENDFORM.                    " REPO_FILL

*&---------------------------------------------------------------------*
*&      Form  REPO_SAVE_CURRENT_QUERY
*&---------------------------------------------------------------------*
*       Save query in the history area
*       Keep only 1000 last queries
*----------------------------------------------------------------------*
FORM REPO_SAVE_CURRENT_QUERY.
  DATA : LT_QUERY         TYPE SOLI_TAB,
         LS_QUERY         LIKE LINE OF LT_QUERY,
         LW_QUERY_WITH_CR TYPE STRING,
         LS_ZTOAD         TYPE ZTOAD,
         LW_NUMBER(3)     TYPE N,
         LW_TIMESTAMP(14) TYPE C,
         LW_DUMMY(1)      TYPE C,                           "#EC NEEDED
         LW_QUERY_LAST    TYPE STRING,
         LW_DATE(10)      TYPE C,
         LW_TIME(8)       TYPE C,
         LW_DUMMY_DATE    TYPE TIMESTAMP.                   "#EC NEEDED

* Get content of abap edit box
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXT
    IMPORTING
      TABLE  = LT_QUERY[]
    EXCEPTIONS
      OTHERS = 1.

* Serialize query into a string
  CLEAR LW_QUERY_WITH_CR.
  LOOP AT LT_QUERY INTO LS_QUERY.
    CONCATENATE LW_QUERY_WITH_CR LS_QUERY CL_ABAP_CHAR_UTILITIES=>CR_LF
                INTO LW_QUERY_WITH_CR.
  ENDLOOP.

* Define timestamp
  LW_TIMESTAMP(8) = SY-DATUM.
  LW_TIMESTAMP+8 = SY-UZEIT.
  LS_ZTOAD-AEDAT = LW_TIMESTAMP.

* Search if query is same as last loaded
  SELECT SINGLE QUERY INTO LW_QUERY_LAST
         FROM ZTOAD
         WHERE QUERYID = W_LAST_LOADED_QUERY.
  IF SY-SUBRC = 0 AND LW_QUERY_LAST = LW_QUERY_WITH_CR.
    RETURN.
  ENDIF.

* Get usergroup
  SELECT SINGLE CLASS INTO LS_ZTOAD-VISIBILITY_GROUP
         FROM USR02
         WHERE BNAME = SY-UNAME.

  CLEAR LW_NUMBER.

* Get last query from history
  CONCATENATE SY-UNAME '#%' INTO LS_ZTOAD-QUERYID.
* aedat is not used but added in select for compatibility reason
  SELECT QUERYID AEDAT
         INTO (LS_ZTOAD-QUERYID, LW_DUMMY_DATE)
         FROM ZTOAD
         UP TO 1 ROWS
         WHERE QUERYID LIKE LS_ZTOAD-QUERYID
         AND OWNER = SY-UNAME
         ORDER BY AEDAT DESCENDING.
  ENDSELECT.
  IF SY-SUBRC = 0.
    SPLIT LS_ZTOAD-QUERYID AT '#' INTO LW_DUMMY LW_NUMBER.
  ENDIF.

  LW_NUMBER = LW_NUMBER + 1.

* For history query, guid = <sy-uname>#NN
  CONCATENATE SY-UNAME '#' LW_NUMBER INTO LS_ZTOAD-QUERYID.
  LS_ZTOAD-OWNER = SY-UNAME.
  LS_ZTOAD-VISIBILITY = C_VISIBILITY_MY.

* Define text for query as timestamp
  WRITE SY-DATLO TO LW_DATE.
  WRITE SY-TIMLO TO LW_TIME.
  CONCATENATE LW_DATE LW_TIME INTO LS_ZTOAD-TEXT SEPARATED BY SPACE.

  LS_ZTOAD-QUERY = LW_QUERY_WITH_CR.
  MODIFY ZTOAD FROM LS_ZTOAD.

  W_LAST_LOADED_QUERY = LS_ZTOAD-QUERYID.

* Reset the modified status
  S_TAB_ACTIVE-O_TEXTEDIT->SET_TEXTMODIFIED_STATUS( ).

* Refresh repository
  PERFORM REPO_FILL.

* Focus on new query
  PERFORM REPO_FOCUS_QUERY USING LS_ZTOAD-QUERYID.
ENDFORM.                    " REPO_SAVE_CURRENT_QUERY

*&---------------------------------------------------------------------*
*&      Form  QUERY_LOAD
*&---------------------------------------------------------------------*
*       Load query
*----------------------------------------------------------------------*
*      -->FW_QUERYID QueryID to load
*      <--FT_QUERY   Saved query
*----------------------------------------------------------------------*
FORM QUERY_LOAD USING FW_QUERYID TYPE ZTOAD-QUERYID
                CHANGING FT_QUERY TYPE TABLE.
  DATA LW_QUERY_WITH_CR TYPE STRING.
  REFRESH FT_QUERY.

  SELECT SINGLE QUERY INTO LW_QUERY_WITH_CR
         FROM ZTOAD
         WHERE QUERYID = FW_QUERYID.
  IF SY-SUBRC = 0.
    SPLIT LW_QUERY_WITH_CR AT CL_ABAP_CHAR_UTILITIES=>CR_LF
                           INTO TABLE FT_QUERY.
  ENDIF.
  W_LAST_LOADED_QUERY = FW_QUERYID.
ENDFORM.                    " QUERY_LOAD

*&---------------------------------------------------------------------*
*&      Form  REPO_FOCUS_QUERY
*&---------------------------------------------------------------------*
*       Focus repository tree on a given queryid
*----------------------------------------------------------------------*
*      -->FW_QUERYID  ID of the query to focus
*----------------------------------------------------------------------*
FORM REPO_FOCUS_QUERY USING FW_QUERYID TYPE ZTOAD-QUERYID.

  READ TABLE T_NODE_REPOSITORY INTO S_NODE_REPOSITORY
             WITH KEY QUERYID = FW_QUERYID.
  IF SY-SUBRC NE 0.
    RETURN.
  ENDIF.

  CALL METHOD O_TREE_REPOSITORY->SET_SELECTED_NODE
    EXPORTING
      NODE_KEY = S_NODE_REPOSITORY-NODE_KEY.

ENDFORM.                    " FOCUS_REPOSITORY

*&---------------------------------------------------------------------*
*&      Form  RESULT_INIT
*&---------------------------------------------------------------------*
*       Initialize ALV grid
*----------------------------------------------------------------------*
FORM RESULT_INIT.

* Create ALV
  CREATE OBJECT S_TAB_ACTIVE-O_ALV_RESULT
    EXPORTING
      I_PARENT = O_CONTAINER_RESULT.

* Register event toolbar to add button
  SET HANDLER O_HANDLE_EVENT->HND_RESULT_TOOLBAR FOR S_TAB_ACTIVE-O_ALV_RESULT.
  SET HANDLER O_HANDLE_EVENT->HND_RESULT_USER_COMMAND FOR S_TAB_ACTIVE-O_ALV_RESULT.

ENDFORM.                    " RESULT_INIT

*&---------------------------------------------------------------------*
*&      Form  SCREEN_INIT_LISTBOX_0200
*&---------------------------------------------------------------------*
*       Fill dropdown listbox with value on screen 200
*----------------------------------------------------------------------*
FORM SCREEN_INIT_LISTBOX_0200.
  TYPE-POOLS VRM.
  DATA : LT_VISIBILITY TYPE VRM_VALUES,
         LS_VISIBILITY LIKE LINE OF LT_VISIBILITY.

  REFRESH LT_VISIBILITY.

  LS_VISIBILITY-KEY = C_VISIBILITY_MY.
  LS_VISIBILITY-TEXT = 'Personal'(m19).
  APPEND LS_VISIBILITY TO LT_VISIBILITY.

  LS_VISIBILITY-KEY = C_VISIBILITY_SHARED.
  LS_VISIBILITY-TEXT = 'User group'(m20).
  APPEND LS_VISIBILITY TO LT_VISIBILITY.

  LS_VISIBILITY-KEY = C_VISIBILITY_ALL.
  LS_VISIBILITY-TEXT = 'All'(m21).
  APPEND LS_VISIBILITY TO LT_VISIBILITY.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      ID     = 'S_OPTIONS-VISIBILITY'
      VALUES = LT_VISIBILITY.

ENDFORM.                    " SCREEN_INIT_LISTBOX_0200

*&---------------------------------------------------------------------*
*&      Form  SCREEN_EXIT
*&---------------------------------------------------------------------*
*       Close the grid. If grid is closed, leave program
*       If sql text area is modified, ask confirmation before leave
*----------------------------------------------------------------------*
FORM SCREEN_EXIT.
  DATA : LW_STATUS    TYPE I,
         LW_ANSWER(1) TYPE C,
         LW_SIZE      TYPE I,
         LW_STRING    TYPE STRING.

* Check if grid is displayed
  CALL METHOD O_SPLITTER->GET_ROW_HEIGHT
    EXPORTING
      ID     = 1
    IMPORTING
      RESULT = LW_SIZE.
  CALL METHOD CL_GUI_CFW=>FLUSH.

* If grid is displayed, BACK action is only to close the grid
  IF LW_SIZE < 100.
    CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
      EXPORTING
        ID     = 1
        HEIGHT = 100.
    RETURN.
  ENDIF.

* Check if textedit is modified
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXTMODIFIED_STATUS
    IMPORTING
      STATUS = LW_STATUS.
  IF LW_STATUS NE 0.
    CONCATENATE 'Current query is not saved. Do you want'(m22)
'to exit without saving or save into history then exit ?'(m56)
                INTO LW_STRING SEPARATED BY SPACE.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TEXT_QUESTION         = LW_STRING
        TEXT_BUTTON_1         = 'Exit'(m23)
        ICON_BUTTON_1         = '@2M@'
        TEXT_BUTTON_2         = 'Save & exit'(m24)
        ICON_BUTTON_2         = '@2L@'
        DEFAULT_BUTTON        = '2'
        DISPLAY_CANCEL_BUTTON = SPACE
      IMPORTING
        ANSWER                = LW_ANSWER.
    IF LW_ANSWER = '2'.
      PERFORM REPO_SAVE_CURRENT_QUERY.
    ENDIF.
  ENDIF.

  LEAVE TO SCREEN 0.
ENDFORM.                    " SCREEN_EXIT

*&---------------------------------------------------------------------*
*&      Form  SCREEN_DISPLAY_HELP
*&---------------------------------------------------------------------*
*       Display help for this program
*----------------------------------------------------------------------*
FORM SCREEN_DISPLAY_HELP.
  DATA : L_REPORT          TYPE STRING,
         L_REPORT_CHAR1(1) TYPE C,
         L_REPORT_CHAR3(3) TYPE C,
         L_COMMENT_FOUND   TYPE I,
         LT_REPORT         LIKE TABLE OF L_REPORT,
         LT_LINES          TYPE RCL_BAG_TLINE,
         LS_LINE           LIKE LINE OF LT_LINES,
         LS_HELP           TYPE HELP_INFO,
         LT_EXCLUDE        TYPE STANDARD TABLE OF STRING.

* Get program source code
  READ REPORT SY-REPID INTO LT_REPORT.

  LS_LINE-TDFORMAT = 'U1'.
  LS_LINE-TDLINE = SY-TITLE.
  APPEND LS_LINE TO LT_LINES.

  LS_LINE-TDFORMAT = 'U3'.
  LS_LINE-TDLINE = '&PURPOSE&'.
  APPEND LS_LINE TO LT_LINES.

  LOOP AT LT_REPORT INTO L_REPORT.
    L_REPORT_CHAR1 = L_REPORT.
    CHECK L_REPORT_CHAR1 = '*'.

* Keep only the second block of comment
* (first block is technical info, third is history)
    L_REPORT_CHAR3 = L_REPORT.
    IF L_REPORT_CHAR3 = '*&-'.
      L_COMMENT_FOUND = L_COMMENT_FOUND + 1.
      IF L_COMMENT_FOUND LE 2.
        CONTINUE.
      ELSE. "l_comment_found > 2
        EXIT.
      ENDIF.
    ENDIF.
    IF L_COMMENT_FOUND = 2.
      L_REPORT = L_REPORT+1.
      L_REPORT_CHAR1 = L_REPORT.
      CASE L_REPORT_CHAR1.
        WHEN '='.
          LS_LINE-TDFORMAT = '='.
        WHEN '3'.
          LS_LINE-TDFORMAT = 'U3'.
        WHEN 'E'.
          LS_LINE-TDFORMAT = 'PE'.
        WHEN OTHERS.
          LS_LINE-TDFORMAT = '*'.
      ENDCASE.
      IF NOT L_REPORT_CHAR1 IS INITIAL.
        L_REPORT = L_REPORT+1.
      ENDIF.
      IF L_REPORT IS INITIAL.
        LS_LINE-TDFORMAT = 'LZ'.
      ENDIF.
      LS_LINE-TDLINE = L_REPORT.
      APPEND LS_LINE TO LT_LINES.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'HELP_DOCULINES_SHOW'
    EXPORTING
      HELP_INFOS = LS_HELP
    TABLES
      EXCLUDEFUN = LT_EXCLUDE
      HELPLINES  = LT_LINES.

ENDFORM.                    " SCREEN_DISPLAY_HELP

*&---------------------------------------------------------------------*
*&      Form  QUERY_PARSE_NOSELECT
*&---------------------------------------------------------------------*
*       Check if query is a known SQL command and if user is allowed
*----------------------------------------------------------------------*
*      -->FW_QUERY   Query to check
*      <--FW_NOAUTH  Unallowed table or command entered
*      <--FW_COMMAND Command to execute (INSERT, DELETE, ...)
*      <--FW_TABLE   Target table of the query
*      <--FW_PARAM   Parameters for the command (WHERE, SET, ...)
*----------------------------------------------------------------------*
FORM QUERY_PARSE_NOSELECT  USING    FW_QUERY TYPE STRING
                           CHANGING FW_NOAUTH TYPE C
                                    FW_COMMAND TYPE STRING
                                    FW_TABLE TYPE STRING
                                    FW_PARAM TYPE STRING.
  DATA : LW_QUERY TYPE STRING,
         LW_TABLE TYPE TABNAME.

  CLEAR : FW_NOAUTH,
          FW_TABLE,
          FW_COMMAND,
          FW_PARAM.

  LW_QUERY = FW_QUERY.
  SPLIT LW_QUERY AT SPACE INTO FW_COMMAND LW_QUERY.
  TRANSLATE FW_COMMAND TO UPPER CASE.
  CASE FW_COMMAND.
    WHEN 'INSERT'.
      SPLIT LW_QUERY AT SPACE INTO FW_TABLE FW_PARAM.
      TRANSLATE FW_TABLE TO UPPER CASE.
      CLEAR SY-SUBRC.
      IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE.
        LW_TABLE = FW_TABLE.
        AUTHORITY-CHECK OBJECT S_CUSTOMIZE-AUTH_OBJECT
                 ID 'TABLE' FIELD LW_TABLE
                 ID 'ACTVT' FIELD S_CUSTOMIZE-ACTVT_INSERT.
      ELSEIF S_CUSTOMIZE-AUTH_INSERT NE '*'
      AND FW_TABLE NP S_CUSTOMIZE-AUTH_INSERT.
        SY-SUBRC = 4.
      ENDIF.
      IF SY-SUBRC NE 0.
        CONCATENATE 'No authorisation for table'(m13) FW_TABLE
                    INTO LW_QUERY SEPARATED BY SPACE.
        MESSAGE LW_QUERY TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
        FW_NOAUTH = ABAP_TRUE.
        RETURN.
      ENDIF.

    WHEN 'UPDATE'.
      SPLIT LW_QUERY AT SPACE INTO FW_TABLE FW_PARAM.
      TRANSLATE FW_TABLE TO UPPER CASE.
      CLEAR SY-SUBRC.
      IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE.
        LW_TABLE = FW_TABLE.
        AUTHORITY-CHECK OBJECT S_CUSTOMIZE-AUTH_OBJECT
                 ID 'TABLE' FIELD LW_TABLE
                 ID 'ACTVT' FIELD S_CUSTOMIZE-ACTVT_UPDATE.
      ELSEIF S_CUSTOMIZE-AUTH_UPDATE NE '*'
      AND FW_TABLE NP S_CUSTOMIZE-AUTH_UPDATE.
        SY-SUBRC = 4.
      ENDIF.
      IF SY-SUBRC NE 0.
        CONCATENATE 'No authorisation for table'(m13) FW_TABLE
                    INTO LW_QUERY SEPARATED BY SPACE.
        MESSAGE LW_QUERY TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
        FW_NOAUTH = ABAP_TRUE.
        RETURN.
      ENDIF.

    WHEN 'DELETE'.
      SPLIT LW_QUERY AT SPACE INTO FW_TABLE FW_PARAM.
      TRANSLATE FW_TABLE TO UPPER CASE.
      IF FW_TABLE = 'FROM'.
        SPLIT FW_PARAM AT SPACE INTO FW_TABLE FW_PARAM.
        TRANSLATE FW_TABLE TO UPPER CASE.
      ENDIF.
      CLEAR SY-SUBRC.
      IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE.
        LW_TABLE = FW_TABLE.
        AUTHORITY-CHECK OBJECT S_CUSTOMIZE-AUTH_OBJECT
                 ID 'TABLE' FIELD LW_TABLE
                 ID 'ACTVT' FIELD S_CUSTOMIZE-ACTVT_DELETE.
      ELSEIF S_CUSTOMIZE-AUTH_DELETE NE '*'
      AND NOT FW_TABLE CP S_CUSTOMIZE-AUTH_DELETE.
        SY-SUBRC = 4.
      ENDIF.
      IF SY-SUBRC NE 0.
        CONCATENATE 'No authorisation for table'(m13) FW_TABLE
                    INTO LW_QUERY SEPARATED BY SPACE.
        MESSAGE LW_QUERY TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
        FW_NOAUTH = ABAP_TRUE.
        RETURN.
      ENDIF.

    WHEN C_NATIVE_COMMAND.
      IF S_CUSTOMIZE-AUTH_OBJECT NE SPACE.
        AUTHORITY-CHECK OBJECT S_CUSTOMIZE-AUTH_OBJECT
                 ID 'ACTVT' FIELD S_CUSTOMIZE-ACTVT_NATIVE.
      ELSEIF S_CUSTOMIZE-AUTH_NATIVE NE ABAP_TRUE.
        SY-SUBRC = 4.
      ENDIF.
      IF SY-SUBRC NE 0.
        CONCATENATE 'SQL command not allowed :'(m25) FW_COMMAND
                    INTO LW_QUERY.
        MESSAGE LW_QUERY TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
        FW_NOAUTH = ABAP_TRUE.
        RETURN.
      ENDIF.
* For native command, replace ' by "
      TRANSLATE LW_QUERY USING '''"'.
      FW_PARAM = LW_QUERY.

    WHEN OTHERS.
      CONCATENATE 'SQL command not allowed :'(m25) FW_COMMAND
                  INTO LW_QUERY.
      MESSAGE LW_QUERY TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
      FW_NOAUTH = ABAP_TRUE.
      RETURN.
  ENDCASE.
ENDFORM.                    " QUERY_PARSE_NOSELECT

*&---------------------------------------------------------------------*
*&      Form  QUERY_GENERATE_NOSELECT
*&---------------------------------------------------------------------*
*       Create all other than SELECT SQL query in a new generated
*       temp program
*----------------------------------------------------------------------*
*      -->FW_COMMAND Query type
*      -->FW_TABLE   Target table of the query
*      -->FW_PARAM   Parameters of the query
*      -->FW_DISPLAY   Display code instead of generated routine
*      <--FW_PROGRAM Name of the generated program
*----------------------------------------------------------------------*
FORM QUERY_GENERATE_NOSELECT  USING    FW_COMMAND TYPE STRING
                                       FW_TABLE TYPE STRING
                                       FW_PARAM TYPE STRING
                                       FW_DISPLAY TYPE C
                              CHANGING FW_PROGRAM TYPE SY-REPID.

  DATA : LT_CODE_STRING      TYPE TABLE OF STRING,
         LW_MESS(255),
         LW_LINE             TYPE I,
         LW_WORD(30),
         LW_STRLEN_STRING    TYPE STRING,
         LW_EXPLICIT         TYPE STRING,
         LW_LENGTH           TYPE I,
         LW_POS              TYPE I,
         LW_FIELDNUM         TYPE I,
         LW_FIELDVAL         TYPE STRING,
         LW_FIELDNAME        TYPE STRING,
         LW_WAIT_NAME(1)     TYPE C,
         LW_CHAR(1)          TYPE C,
         LW_STARTED(1)       TYPE C,
         LW_STARTED_FIELD(1) TYPE C.

  DEFINE C.
    lw_strlen_string = &1.
    perform add_line_to_table using lw_strlen_string
                              changing lt_code_string.
  END-OF-DEFINITION.

* Write Header
  C 'PROGRAM SUBPOOL.'.                                     "#EC NOTEXT
  C '** GENERATED PROGRAM * DO NOT CHANGE IT **'.           "#EC NOTEXT
  C 'type-pools: slis.'.                                    "#EC NOTEXT
  C 'DATA : w_timestart type timestampl,'.                  "#EC NOTEXT
  C '       w_timeend type timestampl.'.                    "#EC NOTEXT
  C ''.
  IF FW_COMMAND = 'INSERT'.
    C 'DATA s_insert type'.                                 "#EC NOTEXT
    C FW_TABLE.
    C '.'.                                                  "#EC NOTEXT
    C 'FIELD-SYMBOLS <fs> TYPE ANY.'.                       "#EC NOTEXT
    C '.'.                                                  "#EC NOTEXT
  ENDIF.

* Write the dynamic subroutine that run the SELECT
  C 'FORM run_sql CHANGING fo_result TYPE REF TO data'.     "#EC NOTEXT
  C '                      fw_time TYPE p'.                 "#EC NOTEXT
  C '                      fw_count TYPE i.'.               "#EC NOTEXT
  C '***************************************'.              "#EC NOTEXT
  C '*            Begin of query           *'.              "#EC NOTEXT
  C '***************************************'.              "#EC NOTEXT
  C 'CLEAR fw_count.'.                                      "#EC NOTEXT
  C 'GET TIME STAMP FIELD w_timestart.'.                    "#EC NOTEXT

  CASE FW_COMMAND.
    WHEN 'UPDATE'.
      C FW_COMMAND.
      C FW_TABLE.
      C FW_PARAM.
      C '.'.
    WHEN 'DELETE'.
      C FW_COMMAND.
      C 'FROM'.                                             "#EC NOTEXT
      C FW_TABLE.
      C FW_PARAM.
      C '.'.
    WHEN 'INSERT'.

      IF FW_PARAM(6) = 'VALUES'.
        LW_LENGTH = STRLEN( FW_PARAM ).
        LW_POS = 6.
        LW_FIELDNUM = 0.
        WHILE LW_POS < LW_LENGTH.
          LW_CHAR = FW_PARAM+LW_POS(1).
          LW_POS = LW_POS + 1.
          IF LW_STARTED = SPACE.
            IF LW_CHAR NE '('. "begin of the list
              CONTINUE.
            ENDIF.
            LW_STARTED = ABAP_TRUE.
            CONTINUE.
          ENDIF.
          IF LW_STARTED_FIELD = SPACE.
            IF LW_CHAR = ')'. "end of the list
              EXIT. "exit while
            ENDIF.

            IF LW_CHAR NE ''''. "field value must start by '
              CONTINUE.
            ENDIF.
            LW_STARTED_FIELD = ABAP_TRUE.
            LW_FIELDVAL = LW_CHAR.
            LW_FIELDNUM = LW_FIELDNUM + 1.
            CONTINUE.
          ENDIF.
          IF LW_CHAR = SPACE.
            CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL
                        SEPARATED BY SPACE.
          ELSE.
            CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL.
          ENDIF.
          IF LW_CHAR = ''''. "end of a field ?
            IF LW_POS < LW_LENGTH.
              LW_CHAR = FW_PARAM+LW_POS(1).
            ELSE.
              CLEAR LW_CHAR.
            ENDIF.
            IF LW_CHAR = ''''. "not end !
              CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL.
              LW_POS = LW_POS + 1.
              CONTINUE.
            ELSE. "end of a field!
              C 'ASSIGN COMPONENT'.                         "#EC NOTEXT
              C LW_FIELDNUM.
              C 'OF STRUCTURE s_insert TO <fs>.'.           "#EC NOTEXT
              C '<fs> = '.                                  "#EC NOTEXT
              C LW_FIELDVAL.
              C '.'.                                        "#EC NOTEXT
              LW_STARTED_FIELD = SPACE.
            ENDIF.
          ENDIF.
        ENDWHILE.
      ELSEIF FW_PARAM(3) = 'SET'.


        LW_LENGTH = STRLEN( FW_PARAM ).
        LW_POS = 3.
        LW_FIELDNUM = 0.
        LW_WAIT_NAME = ABAP_TRUE.
        WHILE LW_POS < LW_LENGTH.
          LW_CHAR = FW_PARAM+LW_POS(1).
          LW_POS = LW_POS + 1.
          IF LW_WAIT_NAME = ABAP_TRUE.
            TRANSLATE LW_CHAR TO UPPER CASE.
            IF LW_CHAR = SPACE OR NOT SY-ABCDE CS LW_CHAR.
              CONTINUE. "not a begin of fieldname
            ENDIF.
            LW_WAIT_NAME = SPACE.
            LW_STARTED = ABAP_TRUE.
            CONCATENATE 's_insert-' LW_CHAR
                        INTO LW_FIELDNAME.                  "#EC NOTEXT
            CONTINUE.
          ENDIF.

          IF LW_STARTED = ABAP_TRUE.
            IF LW_CHAR = SPACE.
              CONCATENATE LW_FIELDNAME LW_CHAR INTO LW_FIELDNAME
                          SEPARATED BY SPACE.
            ELSE.
              CONCATENATE LW_FIELDNAME LW_CHAR INTO LW_FIELDNAME.
            ENDIF.
            IF LW_CHAR = '='. "end of the field name
              LW_STARTED = SPACE.
            ENDIF.

            CONTINUE.
          ENDIF.

          IF LW_STARTED_FIELD NE ABAP_TRUE.
            IF LW_CHAR NE ''''. "field value must start by '
              CONTINUE.
            ENDIF.
            LW_STARTED_FIELD = ABAP_TRUE.
            LW_FIELDVAL = LW_CHAR.
            CONTINUE.
          ENDIF.

          IF LW_CHAR = SPACE.
            CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL
                        SEPARATED BY SPACE.
          ELSE.
            CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL.
          ENDIF.
          IF LW_CHAR = ''''. "end of a field ?
            IF LW_POS < LW_LENGTH.
              LW_CHAR = FW_PARAM+LW_POS(1).
            ELSE.
              CLEAR LW_CHAR.
            ENDIF.
            IF LW_CHAR = ''''. "not end !
              CONCATENATE LW_FIELDVAL LW_CHAR INTO LW_FIELDVAL.
              LW_POS = LW_POS + 1.
              CONTINUE.
            ELSE. "end of a field!
              C LW_FIELDNAME.
              C LW_FIELDVAL.
              C '.'.
              LW_STARTED_FIELD = SPACE.
              LW_WAIT_NAME = ABAP_TRUE.
            ENDIF.
          ENDIF.
        ENDWHILE.
      ELSE.
        MESSAGE 'Error in INSERT syntax : VALUES / SET required'(m26)
                TYPE C_MSG_ERROR.
      ENDIF. "if fw_param(6) = 'VALUES'.
      C FW_COMMAND.
      C 'INTO'.                                             "#EC NOTEXT
      C FW_TABLE.
      C 'VALUES s_insert.'.                                 "#EC NOTEXT
  ENDCASE.

* Get query execution time & affected lines
  C 'IF sy-subrc = 0.'.                                     "#EC NOTEXT
  C '  fw_count = sy-dbcnt.'.                               "#EC NOTEXT
  C 'ENDIF.'.                                               "#EC NOTEXT
  C 'GET TIME STAMP FIELD w_timeend.'.                      "#EC NOTEXT
  C 'fw_time = w_timeend - w_timestart.'.                   "#EC NOTEXT
  C 'ENDFORM.'.                                             "#EC NOTEXT

  CLEAR : LW_LINE,
          LW_WORD,
          LW_MESS.
  SYNTAX-CHECK FOR LT_CODE_STRING PROGRAM SY-REPID
               MESSAGE LW_MESS LINE LW_LINE WORD LW_WORD.
  IF SY-SUBRC NE 0 AND FW_DISPLAY = SPACE.
    MESSAGE LW_MESS TYPE C_MSG_ERROR.
  ENDIF.

  IF FW_DISPLAY = SPACE.
    GENERATE SUBROUTINE POOL LT_CODE_STRING NAME FW_PROGRAM.
  ELSE.
    IF LW_MESS IS NOT INITIAL.
      LW_EXPLICIT = LW_LINE.
      CONCATENATE LW_MESS '(line'(m28) LW_EXPLICIT ',word'(m29)
                  LW_WORD ')'(m30)
                  INTO LW_MESS SEPARATED BY SPACE.
      MESSAGE LW_MESS TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
    ENDIF.
    EDITOR-CALL FOR LT_CODE_STRING DISPLAY-MODE
                TITLE 'Generated code for current query'(t01).
  ENDIF.
ENDFORM.                    " QUERY_GENERATE_NOSELECT

*&---------------------------------------------------------------------*
*&      Form  DDIC_GET_FIELD_FROM_NODE
*&---------------------------------------------------------------------*
*       Get text for a DDIC node
*       Format of the text : tablename~fieldname
*----------------------------------------------------------------------*
*      -->FW_NODE_KEY   DDIC node key
*      -->FW_RELAT_KEY  DDIC parent node key
*      -->FW_TEXT       Text
*----------------------------------------------------------------------*
FORM DDIC_GET_FIELD_FROM_NODE  USING    FW_NODE_KEY TYPE TV_NODEKEY
                                        FW_RELAT_KEY TYPE TV_NODEKEY
                               CHANGING FW_TEXT TYPE STRING.
  DATA : LS_ITEM        LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LS_ITEM_PARENT LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LW_TABLE       TYPE STRING,
         LW_ALIAS       TYPE STRING.

* Get field name
  READ TABLE S_TAB_ACTIVE-T_ITEM_DDIC INTO LS_ITEM
             WITH KEY NODE_KEY = FW_NODE_KEY
                      ITEM_NAME = C_DDIC_COL1.

* Get table name
  READ TABLE S_TAB_ACTIVE-T_ITEM_DDIC INTO LS_ITEM_PARENT
             WITH KEY NODE_KEY = FW_RELAT_KEY
                      ITEM_NAME = C_DDIC_COL1.

* Search for alias
  SPLIT LS_ITEM_PARENT-TEXT AT ' AS ' INTO LW_TABLE LW_ALIAS.
  IF NOT LW_ALIAS IS INITIAL.
    LW_TABLE = LW_ALIAS.
  ENDIF.

* Build tablename~fieldname
  CONCATENATE LW_TABLE '~' LS_ITEM-TEXT INTO FW_TEXT.
  CONCATENATE SPACE FW_TEXT SPACE INTO FW_TEXT RESPECTING BLANKS.

ENDFORM.                    " DDIC_GET_FIELD_FROM_NODE

*&---------------------------------------------------------------------*
*&      Form  EDITOR_PASTE
*&---------------------------------------------------------------------*
*       Paste given text to SQL editor at given position
*----------------------------------------------------------------------*
*      -->FW_TEXT Text to paste in editor
*      -->FW_LINE Line in editor to paste
*      -->FW_POS  Position in the line in editor
*----------------------------------------------------------------------*
FORM EDITOR_PASTE  USING FW_TEXT TYPE STRING
                         FW_LINE TYPE I
                         FW_POS TYPE I.
  DATA : LT_TEXT    TYPE TABLE OF STRING,
         LW_POS     TYPE I,
         LW_LINE    TYPE I,
         LW_MESSAGE TYPE STRING.

*   Set text with new line
  APPEND FW_TEXT TO LT_TEXT.
  IF S_CUSTOMIZE-PASTE_BREAK = ABAP_TRUE.
    LW_POS = FW_POS - 1.
    CLEAR LW_MESSAGE.
    DO LW_POS TIMES.
      CONCATENATE LW_MESSAGE SPACE INTO LW_MESSAGE RESPECTING BLANKS.
    ENDDO.
    APPEND LW_MESSAGE TO LT_TEXT.
  ENDIF.

  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->INSERT_BLOCK_AT_POSITION
    EXPORTING
      LINE     = FW_LINE
      POS      = FW_POS
      TEXT_TAB = LT_TEXT
    EXCEPTIONS
      OTHERS   = 0.

* Set cursor at end of pasted field
  IF S_CUSTOMIZE-PASTE_BREAK = ABAP_TRUE.
    LW_POS = FW_POS.
    LW_LINE = FW_LINE + 1.
  ELSE.
    LW_POS = STRLEN( FW_TEXT ).
    LW_POS = LW_POS + FW_POS.
    LW_LINE = FW_LINE.
  ENDIF.

  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_SELECTION_POS_IN_LINE
    EXPORTING
      LINE   = LW_LINE
      POS    = LW_POS
    EXCEPTIONS
      OTHERS = 0.

* Focus on editor
  CALL METHOD CL_GUI_CONTROL=>SET_FOCUS
    EXPORTING
      CONTROL = S_TAB_ACTIVE-O_TEXTEDIT
    EXCEPTIONS
      OTHERS  = 0.

  CONCATENATE FW_TEXT 'pasted to SQL Editor'(m27)
              INTO LW_MESSAGE SEPARATED BY SPACE.
  MESSAGE LW_MESSAGE TYPE C_MSG_SUCCESS.
ENDFORM.                    " EDITOR_PASTE

*&---------------------------------------------------------------------*
*&      Form  QUERY_PROCESS_NATIVE
*&---------------------------------------------------------------------*
*       Execute a given native sql command
*----------------------------------------------------------------------*
*      -->FW_COMMAND Native SQL Command to execute
*----------------------------------------------------------------------*
FORM QUERY_PROCESS_NATIVE USING FW_COMMAND TYPE STRING.
  DATA : LW_LINES        TYPE I,
         LW_SQL_CODE     TYPE I,
         LW_SQL_MSG(255) TYPE C,
         LW_ROW_NUM      TYPE I,
         LW_COMMAND(255) TYPE C,
         LW_MSG          TYPE STRING,
         LW_TIMESTART    TYPE TIMESTAMPL,
         LW_TIMEEND      TYPE TIMESTAMPL,
         LW_TIME         TYPE P LENGTH 8 DECIMALS 2,
         LW_CHARNUMB(12) TYPE C,
         LW_ANSWER(1)    TYPE C.

* Have a user confirmation before execute Native SQL Command
  CONCATENATE 'Are you sure you want to do a'(m31) FW_COMMAND
              '?'(m33)
              INTO LW_MSG SEPARATED BY SPACE.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TITLEBAR              = 'Warning : critical operation'(t04)
      TEXT_QUESTION         = LW_MSG
      DEFAULT_BUTTON        = '2'
      DISPLAY_CANCEL_BUTTON = SPACE
    IMPORTING
      ANSWER                = LW_ANSWER
    EXCEPTIONS
      TEXT_NOT_FOUND        = 1
      OTHERS                = 2.
  IF SY-SUBRC NE 0 OR LW_ANSWER NE '1'.
    RETURN.
  ENDIF.

  LW_COMMAND = FW_COMMAND.
  LW_LINES = STRLEN( LW_COMMAND ).
  GET TIME STAMP FIELD LW_TIMESTART.
  CALL 'C_DB_EXECUTE'
       ID 'STATLEN' FIELD LW_LINES
       ID 'STATTXT' FIELD LW_COMMAND
       ID 'SQLERR'  FIELD LW_SQL_CODE
       ID 'ERRTXT'  FIELD LW_SQL_MSG
       ID 'ROWNUM'  FIELD LW_ROW_NUM.
  IF SY-SUBRC NE 0.
    MESSAGE LW_SQL_MSG TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
    RETURN.
  ELSE.
    GET TIME STAMP FIELD LW_TIMEEND.
    LW_TIME = CL_ABAP_TSTMP=>SUBTRACT(
                TSTMP1 = LW_TIMEEND
                TSTMP2 = LW_TIMESTART
              ).
    LW_CHARNUMB = LW_TIME.
    CONCATENATE 'Query executed in'(m09) LW_CHARNUMB 'seconds.'(m10)
                INTO LW_MSG SEPARATED BY SPACE.
    CONDENSE LW_MSG.
    MESSAGE LW_MSG TYPE C_MSG_SUCCESS.
  ENDIF.
ENDFORM.                    " QUERY_PROCESS_NATIVE

*&---------------------------------------------------------------------*
*&      Form  ddic_add_tree_zspro
*&---------------------------------------------------------------------*
*       Add nodes from table ZSPRO
*       You can delete this form if not use ZSPRO or dont have a table
*       hierarchy in ZSPRO
*----------------------------------------------------------------------*
FORM DDIC_ADD_TREE_ZSPRO.
  DATA : LO_ZSPRO   TYPE REF TO DATA,
         LS_NODE    LIKE LINE OF S_TAB_ACTIVE-T_NODE_DDIC,
         LS_ITEM    LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LW_NODEKEY TYPE TV_NODEKEY,
         BEGIN OF LS_DDIC_FIELDS,
           TABNAME   TYPE DD03L-TABNAME,
           FIELDNAME TYPE DD03L-FIELDNAME,
           POSITION  TYPE DD03L-POSITION,
           KEYFLAG   TYPE DD03L-KEYFLAG,
           DDTEXT1   TYPE DD03T-DDTEXT,
           DDTEXT2   TYPE DD04T-DDTEXT,
         END OF LS_DDIC_FIELDS,
         LT_DDIC_FIELDS     LIKE TABLE OF LS_DDIC_FIELDS,
         LW_NODE_NUMBER(11) TYPE N,
         LW_FOUND(1)        TYPE C.
  CONSTANTS LC_ZSPRO(30) TYPE C VALUE 'ZSPRO'.
  FIELD-SYMBOLS : <FT_ZSPRO> TYPE STANDARD TABLE,
                  <FS_ZSPRO> TYPE ANY,
                  <FW_ZSPRO> TYPE ANY.
  REFRESH : T_NODE_ZSPRO, T_ITEM_ZSPRO.

* Try to create zspro internal table
  TRY.
      CREATE DATA LO_ZSPRO TYPE TABLE OF (LC_ZSPRO).
    CATCH CX_SY_CREATE_DATA_ERROR.
* If ZSPRO does not exist, leave the subroutine
      RETURN.
  ENDTRY.
  ASSIGN LO_ZSPRO->* TO <FT_ZSPRO>.

* Get all data from ZSPRO (node or table entry)
  SELECT * FROM (LC_ZSPRO)
           INTO TABLE <FT_ZSPRO>
           WHERE NODETYPE = 0
           OR NODETYPE = 1
           OR NODETYPE = SPACE
           ORDER BY RELATKEY SORT.
* If ZSPRO does not contain any valuable data, leave the subroutine
  IF SY-SUBRC NE 0.
    RETURN.
  ENDIF.

* Get field list for each table
  LOOP AT <FT_ZSPRO> ASSIGNING <FS_ZSPRO>.
    ASSIGN COMPONENT 'NODETYPE' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF SY-SUBRC NE 0 OR <FW_ZSPRO> NE 1.
      CONTINUE.
    ENDIF.
    ASSIGN COMPONENT 'NODEPARAM' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF SY-SUBRC = 0.
      LS_DDIC_FIELDS-TABNAME = <FW_ZSPRO>.
      APPEND LS_DDIC_FIELDS TO LT_DDIC_FIELDS.
    ENDIF.
  ENDLOOP.
  IF NOT LT_DDIC_FIELDS IS INITIAL.
    SELECT DD03L~TABNAME DD03L~FIELDNAME DD03L~POSITION
           DD03L~KEYFLAG DD03T~DDTEXT DD04T~DDTEXT
           INTO TABLE LT_DDIC_FIELDS
           FROM DD03L
           LEFT OUTER JOIN DD03T
           ON DD03L~TABNAME = DD03T~TABNAME
           AND DD03L~FIELDNAME = DD03T~FIELDNAME
           AND DD03L~AS4LOCAL = DD03T~AS4LOCAL
           AND DD03T~DDLANGUAGE = SY-LANGU
           LEFT OUTER JOIN DD04T
           ON DD03L~ROLLNAME = DD04T~ROLLNAME
           AND DD03L~AS4LOCAL = DD04T~AS4LOCAL
           AND DD04T~DDLANGUAGE = SY-LANGU
           FOR ALL ENTRIES IN LT_DDIC_FIELDS
           WHERE DD03L~TABNAME = LT_DDIC_FIELDS-TABNAME
           AND DD03L~AS4LOCAL = C_VERS_ACTIVE
           AND DD03L~AS4VERS = SPACE
           AND ( DD03L~COMPTYPE = C_DDIC_DTELM
           OR    DD03L~COMPTYPE = SPACE ).
    SORT LT_DDIC_FIELDS BY TABNAME KEYFLAG DESCENDING POSITION.
    DELETE ADJACENT DUPLICATES FROM LT_DDIC_FIELDS
           COMPARING TABNAME FIELDNAME.
  ENDIF.

  CLEAR LS_NODE.
  LS_NODE-NODE_KEY = 'ZSPRO'.
  LS_NODE-ISFOLDER = ABAP_TRUE.
  LS_NODE-EXPANDER = ABAP_TRUE.
  APPEND LS_NODE TO T_NODE_ZSPRO.

  CLEAR LS_ITEM.
  LS_ITEM-NODE_KEY = 'ZSPRO'.
  LS_ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_TEXT.
  LS_ITEM-ITEM_NAME = C_DDIC_COL1.
  LS_ITEM-TEXT = 'ZSPRO'.
  APPEND LS_ITEM TO T_ITEM_ZSPRO.

  LS_ITEM-ITEM_NAME = C_DDIC_COL2.
  LS_ITEM-TEXT = SPACE.
  APPEND LS_ITEM TO T_ITEM_ZSPRO.

  LOOP AT <FT_ZSPRO> ASSIGNING <FS_ZSPRO>.
    ASSIGN COMPONENT 'NODE_KEY' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    CONCATENATE 'Z' <FW_ZSPRO>+1 INTO LW_NODEKEY.
    CLEAR LS_NODE.
    LS_NODE-NODE_KEY = LW_NODEKEY.

    ASSIGN COMPONENT 'RELATKEY' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF <FW_ZSPRO> IS INITIAL.
      LS_NODE-RELATKEY = 'ZSPRO'.
    ELSE.
      CONCATENATE 'Z' <FW_ZSPRO>+1 INTO LS_NODE-RELATKEY.
    ENDIF.
    LS_NODE-ISFOLDER = ABAP_TRUE.

    ASSIGN COMPONENT 'NODETYPE' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF <FW_ZSPRO> = 1. "table entry
      LS_NODE-N_IMAGE = '@PO@'.
      LS_NODE-EXP_IMAGE = '@PO@'.
    ENDIF.
    LS_NODE-EXPANDER = ABAP_TRUE.
    APPEND LS_NODE TO T_NODE_ZSPRO.

    CLEAR LS_ITEM.
    LS_ITEM-NODE_KEY = LW_NODEKEY.
    LS_ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_TEXT.
    LS_ITEM-ITEM_NAME = C_DDIC_COL1.
    IF <FW_ZSPRO> = 1. "table entry
      ASSIGN COMPONENT 'NODEPARAM' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
      LS_ITEM-TEXT = <FW_ZSPRO>.
    ELSE.
      ASSIGN COMPONENT 'TEXT' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
      LS_ITEM-TEXT = <FW_ZSPRO>.
    ENDIF.
    APPEND LS_ITEM TO T_ITEM_ZSPRO.

    LS_ITEM-ITEM_NAME = C_DDIC_COL2.
    ASSIGN COMPONENT 'NODETYPE' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF <FW_ZSPRO> = 1. "table entry
      ASSIGN COMPONENT 'TEXT' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
      LS_ITEM-TEXT = <FW_ZSPRO>.
    ELSE.
      LS_ITEM-TEXT = SPACE.
    ENDIF.
    APPEND LS_ITEM TO T_ITEM_ZSPRO.

* For each table entry, add all fields
    ASSIGN COMPONENT 'NODETYPE' OF STRUCTURE <FS_ZSPRO> TO <FW_ZSPRO>.
    IF <FW_ZSPRO> = 1.
      ASSIGN COMPONENT 'NODEPARAM' OF STRUCTURE <FS_ZSPRO>
                                   TO <FW_ZSPRO>.
      LOOP AT LT_DDIC_FIELDS INTO LS_DDIC_FIELDS
                             WHERE TABNAME = <FW_ZSPRO>.
        CLEAR LS_NODE.
        LW_NODE_NUMBER = LW_NODE_NUMBER + 1.
        CONCATENATE 'F' LW_NODE_NUMBER INTO LS_NODE-NODE_KEY.
        LS_NODE-RELATKEY = LW_NODEKEY.
        LS_NODE-RELATSHIP = CL_GUI_COLUMN_TREE=>RELAT_LAST_CHILD.
        IF LS_DDIC_FIELDS-KEYFLAG = SPACE.
          LS_NODE-N_IMAGE = '@3W@'.
          LS_NODE-EXP_IMAGE = '@3W@'.
        ELSE.
          LS_NODE-N_IMAGE = '@3V@'.
          LS_NODE-EXP_IMAGE = '@3V@'.
        ENDIF.
        LS_NODE-DRAGDROPID = W_DRAGDROP_HANDLE_TREE.
        APPEND LS_NODE TO T_NODE_ZSPRO.

        CLEAR LS_ITEM.
        LS_ITEM-NODE_KEY = LS_NODE-NODE_KEY.
        LS_ITEM-CLASS = CL_GUI_COLUMN_TREE=>ITEM_CLASS_TEXT.
        LS_ITEM-ITEM_NAME = C_DDIC_COL1.
        LS_ITEM-TEXT = LS_DDIC_FIELDS-FIELDNAME.
        APPEND LS_ITEM TO T_ITEM_ZSPRO.
        LS_ITEM-ITEM_NAME = C_DDIC_COL2.
        IF NOT LS_DDIC_FIELDS-DDTEXT1 IS INITIAL.
          LS_ITEM-TEXT = LS_DDIC_FIELDS-DDTEXT1.
        ELSE.
          LS_ITEM-TEXT = LS_DDIC_FIELDS-DDTEXT2.
        ENDIF.
        APPEND LS_ITEM TO T_ITEM_ZSPRO.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

* Clean Empty nodes
  DO.
    LW_FOUND = SPACE.
    LOOP AT T_NODE_ZSPRO INTO LS_NODE WHERE ISFOLDER = ABAP_TRUE.
      READ TABLE T_NODE_ZSPRO WITH KEY RELATKEY = LS_NODE-NODE_KEY
                 TRANSPORTING NO FIELDS.
      IF SY-SUBRC NE 0.
        LW_FOUND = ABAP_TRUE.
        DELETE T_NODE_ZSPRO.
        DELETE T_ITEM_ZSPRO WHERE NODE_KEY = LS_NODE-NODE_KEY.
      ENDIF.
    ENDLOOP.
    IF LW_FOUND = SPACE.
      EXIT.
    ENDIF.
  ENDDO.
ENDFORM.                    "ddic_add_tree_zspro

*&---------------------------------------------------------------------*
*&      Form  REPO_DELETE_HISTORY
*&---------------------------------------------------------------------*
*       Delete given history entry
*----------------------------------------------------------------------*
*      -->FW_NODE_KEY Node key of history to delete
*      <--FW_SUBRC    Return code
*----------------------------------------------------------------------*
FORM REPO_DELETE_HISTORY USING FW_NODE_KEY TYPE TV_NODEKEY
                         CHANGING FW_SUBRC TYPE I.
  DATA LS_HISTO LIKE S_NODE_REPOSITORY.

  READ TABLE T_NODE_REPOSITORY INTO LS_HISTO
             WITH KEY NODE_KEY = FW_NODE_KEY.
  IF SY-SUBRC = 0 AND LS_HISTO-EDIT NE SPACE.
    DELETE FROM ZTOAD WHERE QUERYID = LS_HISTO-QUERYID.
    IF SY-SUBRC = 0.
      CALL METHOD O_TREE_REPOSITORY->DELETE_NODE
        EXPORTING
          NODE_KEY = FW_NODE_KEY.
    ENDIF.
  ENDIF.
  FW_SUBRC = SY-SUBRC.
ENDFORM.                    " REPO_DELETE_HISTORY

*&---------------------------------------------------------------------*
*&      Form  options_load
*&---------------------------------------------------------------------*
*       Get saved options from user parameters table
*----------------------------------------------------------------------*
FORM OPTIONS_LOAD.
  DATA : LW_OPTIONS  TYPE USR05-PARVA,
         LW_ROWS(10) TYPE C.
  GET PARAMETER ID 'ZTOAD' FIELD LW_OPTIONS.                "#EC EXISTS
  IF SY-SUBRC = 0.
    SPLIT LW_OPTIONS AT ';' INTO LW_ROWS
                                 S_CUSTOMIZE-PASTE_BREAK
                                 S_CUSTOMIZE-TECHNAME
                                 LW_OPTIONS. "dummy
    S_CUSTOMIZE-DEFAULT_ROWS = LW_ROWS.
  ENDIF.
ENDFORM.                    " options_load

*&---------------------------------------------------------------------*
*&      Form  options_save
*&---------------------------------------------------------------------*
*       Save user options in standard user parameters table
*----------------------------------------------------------------------*
FORM OPTIONS_SAVE.
  DATA : LW_OPTIONS  TYPE USR05-PARVA,
         LW_ROWS(10) TYPE C.

  LW_ROWS =   S_CUSTOMIZE-DEFAULT_ROWS.
  CONDENSE LW_ROWS NO-GAPS.
  CONCATENATE LW_ROWS
              S_CUSTOMIZE-PASTE_BREAK
              S_CUSTOMIZE-TECHNAME
              INTO LW_OPTIONS
              SEPARATED BY ';'.

  CALL FUNCTION 'SMAN_SET_USER_PARAMETER'
    EXPORTING
      PARAMETER_ID    = 'ZTOAD'
      PARAMETER_VALUE = LW_OPTIONS
    EXCEPTIONS
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE E082(S1). "Error saving parameter changes
  ENDIF.

ENDFORM.                    "options_save

*&---------------------------------------------------------------------*
*&      Form  DDIC_REFRESH_TREE
*&---------------------------------------------------------------------*
*       Refresh DDIC tree with current query
*----------------------------------------------------------------------*
FORM DDIC_REFRESH_TREE.
  DATA : LW_QUERY        TYPE STRING,
         LW_QUERY2       TYPE STRING,
         LW_SELECT       TYPE STRING,
         LW_FROM         TYPE STRING,
         LW_FROM2        TYPE STRING,
         LW_WHERE        TYPE STRING,
         LW_UNION        TYPE STRING,
         LW_ROWS(6)      TYPE N,
         LW_NOAUTH(1)    TYPE C,
         LW_NEWSYNTAX(1) TYPE C,
         LW_ERROR(1)     TYPE C,
         LT_SELECT_TABLE TYPE SOLI_TAB.

* Get only usefull code for current query
  PERFORM EDITOR_GET_QUERY USING SPACE CHANGING LW_QUERY LT_SELECT_TABLE.

* Parse Query
  PERFORM QUERY_PARSE USING LW_QUERY
                      CHANGING LW_SELECT LW_FROM LW_WHERE
                               LW_UNION LW_ROWS LW_NOAUTH
                               LW_NEWSYNTAX LW_ERROR.

  IF LW_NOAUTH NE SPACE OR LW_ERROR NE SPACE.
    RETURN.
  ELSEIF LW_SELECT IS INITIAL.
    PERFORM QUERY_PARSE_NOSELECT USING LW_QUERY
                                 CHANGING LW_NOAUTH LW_SELECT
                                          LW_FROM LW_WHERE.
    IF LW_NOAUTH NE SPACE OR LW_SELECT = C_NATIVE_COMMAND.
      RETURN.
    ENDIF.
  ENDIF.
* Manage unioned queries
  WHILE NOT LW_UNION IS INITIAL.
* Parse Query
    LW_QUERY2 = LW_UNION.
    PERFORM QUERY_PARSE USING LW_QUERY2
                        CHANGING LW_SELECT LW_FROM2 LW_WHERE
                                 LW_UNION LW_ROWS LW_NOAUTH
                                 LW_NEWSYNTAX LW_ERROR.
    IF NOT LW_FROM2 IS INITIAL.
      CONCATENATE LW_FROM 'JOIN' LW_FROM2
                  INTO LW_FROM SEPARATED BY SPACE.
    ENDIF.
    IF LW_NOAUTH NE SPACE OR LW_ERROR NE SPACE.
      RETURN.
    ENDIF.
  ENDWHILE.

  PERFORM TAB_UPDATE_TITLE USING LW_QUERY.

* Refresh ddic tree with list of table/fields of the actual query
  PERFORM DDIC_SET_TREE USING LW_FROM.
ENDFORM.                    " DDIC_REFRESH_TREE

*&---------------------------------------------------------------------*
*&      Form  DDIC_FIND_IN_TREE
*&---------------------------------------------------------------------*
*       Display popup to search a table in DDIC tree
*----------------------------------------------------------------------*
FORM DDIC_FIND_IN_TREE.
  DATA : LS_SVAL        TYPE SVAL,
         LT_SVAL        LIKE TABLE OF LS_SVAL,
         LW_RETURNCODE  TYPE C,
         LW_SEARCH      TYPE STRING,
         LT_SEARCH      LIKE TABLE OF LW_SEARCH,
         LS_ITEM_DDIC   LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LW_SEARCH_TERM TYPE STRING,
         LW_SEARCH_LINE TYPE I,
         LW_REST        TYPE I,
         LW_NODE_KEY    TYPE TV_NODEKEY,
         LT_NODEKEY     TYPE TABLE OF TV_NODEKEY.

* Build search table
  REFRESH LT_SEARCH.
  LOOP AT S_TAB_ACTIVE-T_ITEM_DDIC INTO LS_ITEM_DDIC.
    LW_SEARCH = LS_ITEM_DDIC-TEXT.
    APPEND LW_SEARCH TO LT_SEARCH.
    APPEND LS_ITEM_DDIC-NODE_KEY TO LT_NODEKEY.
  ENDLOOP.

* Ask for selection search
  LS_SVAL-TABNAME = 'RSDXX'.
  LS_SVAL-FIELDNAME = 'FINDSTR'.
  LS_SVAL-VALUE = SPACE.
  APPEND LS_SVAL TO LT_SVAL.
  DO.
    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        POPUP_TITLE     = SPACE
      IMPORTING
        RETURNCODE      = LW_RETURNCODE
      TABLES
        FIELDS          = LT_SVAL
      EXCEPTIONS
        ERROR_IN_FIELDS = 1
        OTHERS          = 2.
    IF SY-SUBRC NE 0 OR LW_RETURNCODE NE SPACE.
      EXIT. "exit do
    ENDIF.
    READ TABLE LT_SVAL INTO LS_SVAL INDEX 1.
    IF LS_SVAL-VALUE = SPACE.
      EXIT. "exit do
    ENDIF.

* For new search, start from line 1
    IF LW_SEARCH_TERM NE LS_SVAL-VALUE.
      LW_SEARCH_TERM = LS_SVAL-VALUE.
      LW_SEARCH_LINE = 1.
* For next result of same search, start from next line
    ELSE.
      LW_REST = LW_SEARCH_LINE MOD 2.
      LW_SEARCH_LINE = LW_SEARCH_LINE + 1 + LW_REST.
    ENDIF.

    FIND FIRST OCCURRENCE OF LS_SVAL-VALUE IN TABLE LT_SEARCH
         FROM LW_SEARCH_LINE
         IN CHARACTER MODE IGNORING CASE
         MATCH LINE LW_SEARCH_LINE.

* Search string &1 not found
    IF SY-SUBRC NE 0 AND LW_SEARCH_LINE = 1.
      MESSAGE S065(0K) WITH LW_SEARCH_TERM DISPLAY LIKE C_MSG_ERROR.
      CLEAR LW_SEARCH_LINE.
      CLEAR LW_SEARCH_TERM.

* Last selected entry reached
    ELSEIF SY-SUBRC NE 0.
      MESSAGE S066(0K) DISPLAY LIKE C_MSG_ERROR.
      CLEAR LW_SEARCH_LINE.
      CLEAR LW_SEARCH_TERM.

* Found
    ELSE.
      MESSAGE 'String found'(m04) TYPE C_MSG_SUCCESS.
      READ TABLE LT_NODEKEY INTO LW_NODE_KEY INDEX LW_SEARCH_LINE.
      CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->SET_SELECTED_NODE
        EXPORTING
          NODE_KEY = LW_NODE_KEY.
      CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->ENSURE_VISIBLE
        EXPORTING
          NODE_KEY = LW_NODE_KEY.
    ENDIF.

  ENDDO.
ENDFORM.                    " DDIC_FIND_IN_TREE

*&---------------------------------------------------------------------*
*&      Form  OPTIONS_INIT
*&---------------------------------------------------------------------*
*       Create option panel
*----------------------------------------------------------------------*
FORM OPTIONS_INIT.
  DATA : LT_PTAB TYPE WDY_WB_PROPERTY_TAB,
         LS_PTAB TYPE WDY_WB_PROPERTY.

* Create a custom container linked to the custom controm on screen 300
  CREATE OBJECT O_CONTAINER_OPTIONS
    EXPORTING
      CONTAINER_NAME              = 'CUSTCONT2'
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

* Create the property object and link it to the custom controm
  CREATE OBJECT O_OPTIONS
    EXPORTING
      PARENT                    = O_CONTAINER_OPTIONS
    EXCEPTIONS
      CNTL_ERROR                = 1
      CNTL_SYSTEM_ERROR         = 2
      ILLEGAL_EVENT_COMBINATION = 3
      OTHERS                    = 4.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

* Define Column title of the property object
  CALL METHOD O_OPTIONS->INITIALIZE
    EXPORTING
      PROPERTY_COLUMN_TITLE = 'Property'(m44)
      VALUE_COLUMN_TITLE    = 'Value'(m45)
      FOCUS_ROW             = 1
      SCROLLABLE            = ABAP_TRUE.

  O_OPTIONS->SET_ENABLED( ABAP_TRUE ).

* paste_break
  LS_PTAB-NAME = 'PB'.
  LS_PTAB-TYPE = CL_WDY_WB_PROPERTY_BOX=>PROPERTY_TYPE_BOOLEAN.
  LS_PTAB-ENABLED = ABAP_TRUE.
  LS_PTAB-VALUE = S_CUSTOMIZE-PASTE_BREAK.
  CONCATENATE '@74\Q'
    'Add break line after pasting ddic field into sql editor'(m46)
    '@' 'Line Break'(m47) INTO LS_PTAB-DISPLAY_NAME.
  APPEND LS_PTAB TO LT_PTAB.

* default up to xxx rows
  LS_PTAB-NAME = 'MAXROWS'.
  LS_PTAB-TYPE = CL_WDY_WB_PROPERTY_BOX=>PROPERTY_TYPE_INTEGER.
  LS_PTAB-ENABLED = ABAP_TRUE.
  LS_PTAB-VALUE = S_CUSTOMIZE-DEFAULT_ROWS.
  CONCATENATE '@3W\Q'
    'Default max number of displayed lines for SELECT'(m48)
    '@' 'Max Rows'(m49) INTO LS_PTAB-DISPLAY_NAME.
  APPEND LS_PTAB TO LT_PTAB.

* default up to xxx rows
  LS_PTAB-NAME = 'TECH'.
  LS_PTAB-TYPE = CL_WDY_WB_PROPERTY_BOX=>PROPERTY_TYPE_BOOLEAN.
  LS_PTAB-ENABLED = ABAP_TRUE.
  LS_PTAB-VALUE = S_CUSTOMIZE-TECHNAME.
  CONCATENATE '@AJ\Q'
    'Display technical name in query result display'(m52)
    '@' 'Technical name'(m53) INTO LS_PTAB-DISPLAY_NAME.
  APPEND LS_PTAB TO LT_PTAB.

* Fill properties/values
  CALL METHOD O_OPTIONS->SET_PROPERTIES
    EXPORTING
      PROPERTIES = LT_PTAB
      REFRESH    = ABAP_TRUE.
ENDFORM.                    " OPTIONS_INIT

*&---------------------------------------------------------------------*
*&      Form  OPTIONS_DISPLAY
*&---------------------------------------------------------------------*
*       Display options panel
*----------------------------------------------------------------------*
FORM OPTIONS_DISPLAY.
  DATA : LT_PTAB TYPE WDY_WB_PROPERTY_TAB,
         LS_PTAB TYPE WDY_WB_PROPERTY.

* If not first display, refresh properties values
  IF NOT O_OPTIONS IS INITIAL.
    LT_PTAB = O_OPTIONS->GET_PROPERTIES( ).
    LOOP AT LT_PTAB INTO LS_PTAB.
      CASE LS_PTAB-NAME.
        WHEN 'PB'.
          LS_PTAB-VALUE = S_CUSTOMIZE-PASTE_BREAK.
        WHEN 'MAXROWS'.
          LS_PTAB-VALUE = S_CUSTOMIZE-DEFAULT_ROWS.
        WHEN 'TECH'.
          LS_PTAB-VALUE = S_CUSTOMIZE-TECHNAME.
      ENDCASE.
      CALL METHOD O_OPTIONS->UPDATE_PROPERTY
        EXPORTING
          PROPERTY = LS_PTAB.
    ENDLOOP.
  ENDIF.

* Display properties panel
  CALL SCREEN 300 STARTING AT 60 10
                  ENDING AT 90 16.
  IF W_OKCODE NE 'OK'.
    RETURN.
  ENDIF.

* Update values if not well refreshed in o_options
  CALL METHOD O_OPTIONS->DISPATCH
    EXPORTING
      CARGO             = W_OKCODE
      EVENTID           = 18
      IS_SHELLEVENT     = SPACE
      IS_SYSTEMDISPATCH = SPACE
    EXCEPTIONS
      OTHERS            = 0.

* Update values in s_customize
  LT_PTAB = O_OPTIONS->GET_PROPERTIES( ).
  LOOP AT LT_PTAB INTO LS_PTAB.
    CASE LS_PTAB-NAME.
      WHEN 'PB'.
        S_CUSTOMIZE-PASTE_BREAK = LS_PTAB-VALUE.
      WHEN 'MAXROWS'.
        S_CUSTOMIZE-DEFAULT_ROWS = LS_PTAB-VALUE.
      WHEN 'TECH'.
        S_CUSTOMIZE-TECHNAME = LS_PTAB-VALUE.
    ENDCASE.
  ENDLOOP.

* Save values in user parameters
  PERFORM OPTIONS_SAVE.
ENDFORM.                    " OPTIONS_DISPLAY

*&---------------------------------------------------------------------*
*&      Form  RESULT_SAVE_FILE
*&---------------------------------------------------------------------*
*       Save results into local file
*       - 1 line of header is written with technical column name
*       - Fields are separated by TAB
*       - Blank at end of char fields are removed
*----------------------------------------------------------------------*
*      -->FO_RESULT    Reference to data to display
*      -->FT_FIELDS    Field list
*----------------------------------------------------------------------*
FORM RESULT_SAVE_FILE USING FO_RESULT TYPE REF TO DATA
                            FT_FIELDS TYPE TY_FIELDLIST_TABLE.

  DATA : LW_FILENAME TYPE STRING,
         LT_FILE_F4  TYPE FILETABLE,
         LS_FILE_F4  LIKE LINE OF LT_FILE_F4,
         LW_RC       TYPE I,
         LW_FILTER   TYPE STRING,
         LW_TITLE    TYPE STRING,
         BEGIN OF LS_FIELD_OUT,
           NAME TYPE CHAR30,
         END OF LS_FIELD_OUT,
         LT_FIELDS   LIKE TABLE OF LS_FIELD_OUT,
         LS_FIELD_IN LIKE LINE OF FT_FIELDS.

  FIELD-SYMBOLS: <LFT_DATA> TYPE ANY TABLE.

  LW_FILTER = 'CSV File (*.csv)|*.csv'(m51).
  LW_TITLE = 'Download results into file'(m63).
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE = LW_TITLE
      FILE_FILTER  = LW_FILTER
    CHANGING
      FILE_TABLE   = LT_FILE_F4
      RC           = LW_RC
    EXCEPTIONS
      OTHERS       = 0.
  READ TABLE LT_FILE_F4 INTO LS_FILE_F4 INDEX 1.
  IF SY-SUBRC = 0.
    LW_FILENAME = LS_FILE_F4.
  ENDIF.
  IF LW_FILENAME IS INITIAL.
    RETURN.
  ENDIF.

  ASSIGN FO_RESULT->* TO <LFT_DATA>.
  LOOP AT FT_FIELDS INTO LS_FIELD_IN.
    APPEND LS_FIELD_IN-REF_FIELD TO LT_FIELDS.
  ENDLOOP.
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
    EXPORTING
      FILENAME              = LW_FILENAME
      WRITE_FIELD_SEPARATOR = ABAP_TRUE
      TRUNC_TRAILING_BLANKS = ABAP_TRUE
      FIELDNAMES            = LT_FIELDS
    CHANGING
      DATA_TAB              = <LFT_DATA>
    EXCEPTIONS
      OTHERS                = 0.

ENDFORM.                    " RESULT_SAVE_FILE

*&---------------------------------------------------------------------*
*&      Form  DDIC_F4
*&---------------------------------------------------------------------*
*       Display F4 help on selected DDIC tree field
*       Paste selected value in SQL Editor
*----------------------------------------------------------------------*
FORM DDIC_F4.
  DATA : LW_TABLE      TYPE DFIES-TABNAME,
         LW_FIELD      TYPE DFIES-FIELDNAME,
         LT_VAL        TYPE TABLE OF DDSHRETVAL,
         LS_VAL        LIKE LINE OF LT_VAL,
         LW_NODEKEY    TYPE TV_NODEKEY,
         LW_ITEM       TYPE TV_ITMNAME,                     "#EC NEEDED
         LS_NODE       LIKE LINE OF S_TAB_ACTIVE-T_NODE_DDIC,
         LS_ITEM       LIKE LINE OF S_TAB_ACTIVE-T_ITEM_DDIC,
         LW_LINE_START TYPE I,
         LW_POS_START  TYPE I,
         LW_LINE_END   TYPE I,
         LW_POS_END    TYPE I,
         LW_VAL        TYPE STRING,
         LW_DUMMY      TYPE C.                              "#EC NEEDED

* Get selection in ddic tree
  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->GET_SELECTED_NODE "line selected
    IMPORTING
      NODE_KEY = LW_NODEKEY.
  IF LW_NODEKEY IS INITIAL.
    CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->GET_SELECTED_ITEM "item selected
      IMPORTING
        NODE_KEY  = LW_NODEKEY
        ITEM_NAME = LW_ITEM.
  ENDIF.
  IF LW_NODEKEY IS INITIAL.
    RETURN.
  ENDIF.

* Check selection is a field
  READ TABLE S_TAB_ACTIVE-T_NODE_DDIC INTO LS_NODE
             WITH KEY NODE_KEY = LW_NODEKEY.
  IF SY-SUBRC NE 0 OR LS_NODE-ISFOLDER = ABAP_TRUE.
    RETURN.
  ENDIF.

* Get field name
  READ TABLE S_TAB_ACTIVE-T_ITEM_DDIC INTO LS_ITEM
             WITH KEY NODE_KEY = LW_NODEKEY
                      ITEM_NAME = C_DDIC_COL1.
  LW_FIELD = LS_ITEM-TEXT.

* Get table name
  READ TABLE S_TAB_ACTIVE-T_ITEM_DDIC INTO LS_ITEM
             WITH KEY NODE_KEY = LS_NODE-RELATKEY
                      ITEM_NAME = C_DDIC_COL1.
  SPLIT LS_ITEM-TEXT AT ' AS ' INTO LW_TABLE LW_DUMMY.

* Display standard value-list
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
    EXPORTING
      FIELDNAME  = LW_FIELD
      TABNAME    = LW_TABLE
    TABLES
      RETURN_TAB = LT_VAL
    EXCEPTIONS
      OTHERS     = 1.

  IF SY-SUBRC = 0.
    READ TABLE LT_VAL INTO LS_VAL INDEX 1.
    CONCATENATE '''' LS_VAL-FIELDVAL '''' INTO LW_VAL.
    CONCATENATE SPACE LW_VAL INTO LW_VAL RESPECTING BLANKS.

* Get current cursor position/selection in editor
    CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_SELECTION_POS
      IMPORTING
        FROM_LINE = LW_LINE_START
        FROM_POS  = LW_POS_START
        TO_LINE   = LW_LINE_END
        TO_POS    = LW_POS_END
      EXCEPTIONS
        OTHERS    = 4.
    IF SY-SUBRC NE 0.
      MESSAGE 'Cannot get cursor position'(m35) TYPE C_MSG_ERROR.
    ENDIF.

*   If text is selected/highlighted, delete it
    IF LW_LINE_START NE LW_LINE_END
    OR LW_POS_START NE LW_POS_END.
      CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->DELETE_TEXT
        EXPORTING
          FROM_LINE = LW_LINE_START
          FROM_POS  = LW_POS_START
          TO_LINE   = LW_LINE_END
          TO_POS    = LW_POS_END.
    ENDIF.

    PERFORM EDITOR_PASTE USING LW_VAL LW_LINE_START LW_POS_START.
  ENDIF.

ENDFORM.                    " DDIC_F4

*&---------------------------------------------------------------------*
*&      Form  EDITOR_GET_DEFAULT_QUERY
*&---------------------------------------------------------------------*
*       Get default query
*----------------------------------------------------------------------*
*      <--FT_QUERY  Default query content
*----------------------------------------------------------------------*
FORM EDITOR_GET_DEFAULT_QUERY  CHANGING FT_QUERY TYPE TABLE.
  DATA LW_STRING TYPE STRING.

  APPEND '* Type here your query title' TO FT_QUERY.        "#EC NOTEXT
  APPEND '' TO FT_QUERY.
  APPEND 'SELECT *' TO FT_QUERY.                            "#EC NOTEXT
  APPEND 'FROM <table_name>' TO FT_QUERY.                   "#EC NOTEXT

  IF S_CUSTOMIZE-DEFAULT_ROWS NE 0.
    LW_STRING = S_CUSTOMIZE-DEFAULT_ROWS.
    CONDENSE LW_STRING NO-GAPS.
    CONCATENATE 'UP TO'
                LW_STRING
                'ROWS'
                INTO LW_STRING SEPARATED BY SPACE.
    APPEND LW_STRING TO FT_QUERY.                           "#EC NOTEXT
  ENDIF.

  APPEND 'WHERE <conditions>' TO FT_QUERY.                  "#EC NOTEXT
  APPEND '.' TO FT_QUERY.                                   "#EC NOTEXT

ENDFORM.                    " EDITOR_GET_DEFAULT_QUERY

*&---------------------------------------------------------------------*
*&      Form  TAB_NEW
*&---------------------------------------------------------------------*
*       Open a new tab
*----------------------------------------------------------------------*
FORM TAB_NEW.
  DATA : L_NUMB TYPE I,
         L_TAB  TYPE STRING.

  DESCRIBE TABLE T_TABS LINES L_NUMB.
  IF L_NUMB GE 30.
    MESSAGE 'You cannot open more than 30 tabs'(m64)
            TYPE C_MSG_SUCCESS DISPLAY LIKE C_MSG_ERROR.
    RETURN.
  ENDIF.

  PERFORM LEAVE_CURRENT_TAB.

* Hide alv pane if displayed
  S_TAB_ACTIVE-ROW_HEIGHT = 100.
  CALL METHOD O_SPLITTER->SET_ROW_HEIGHT
    EXPORTING
      ID     = 1
      HEIGHT = S_TAB_ACTIVE-ROW_HEIGHT.

* Start new tab
  L_TAB = L_NUMB + 1.
  CONCATENATE 'TAB' L_TAB INTO L_TAB.
  CONDENSE L_TAB NO-GAPS.
  W_TABSTRIP-ACTIVETAB = L_TAB.
*  w_tabstrip-%_SCROLLPOSITION = l_tab. "bugged

* Initialize new editor / ddic / alv
  PERFORM DDIC_INIT.
  PERFORM EDITOR_INIT.
  PERFORM RESULT_INIT.

* Tab management
  APPEND S_TAB_ACTIVE TO T_TABS.

ENDFORM.                    " TAB_NEW

*&---------------------------------------------------------------------*
*&      Form  LEAVE_CURRENT_TAB
*&---------------------------------------------------------------------*
*       Hide editor / ddic / alv for current tab and save state
*----------------------------------------------------------------------*
FORM LEAVE_CURRENT_TAB.
* Hide current editor / ddic / alv
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->SET_VISIBLE
    EXPORTING
      VISIBLE = SPACE.

  CALL METHOD S_TAB_ACTIVE-O_TREE_DDIC->SET_VISIBLE
    EXPORTING
      VISIBLE = SPACE.

  IF NOT S_TAB_ACTIVE-O_ALV_RESULT IS INITIAL.
    CALL METHOD S_TAB_ACTIVE-O_ALV_RESULT->SET_VISIBLE
      EXPORTING
        VISIBLE = SPACE.
  ENDIF.
* Save ALV split height
  CALL METHOD O_SPLITTER->GET_ROW_HEIGHT
    EXPORTING
      ID     = 1
    IMPORTING
      RESULT = S_TAB_ACTIVE-ROW_HEIGHT.
  CALL METHOD CL_GUI_CFW=>FLUSH.

  PERFORM TAB_UPDATE_TITLE USING SPACE.

  MODIFY T_TABS FROM S_TAB_ACTIVE INDEX W_TABSTRIP-ACTIVETAB+3.
  CLEAR S_TAB_ACTIVE.
ENDFORM.                    " LEAVE_CURRENT_TAB

*&---------------------------------------------------------------------*
*&      Form  TAB_UPDATE_TITLE
*&---------------------------------------------------------------------*
*       Update tab title regarding current query
*       - Display first line query if it is a comment
*       - Display query as title in other cases
*----------------------------------------------------------------------*
*      -->FW_QUERY Complete query
*----------------------------------------------------------------------*
FORM TAB_UPDATE_TITLE USING FW_QUERY TYPE STRING.
  DATA : LW_NAME(30)     TYPE C,
         LT_QUERY        TYPE SOLI_TAB,
         LS_QUERY        LIKE LINE OF LT_QUERY,
         LW_QUERY        TYPE STRING,
         LT_SELECT_TABLE TYPE SOLI_TAB.
  FIELD-SYMBOLS <FS> TYPE ANY.
  IF W_TABSTRIP-ACTIVETAB IS INITIAL.
    LW_NAME = 'S_TAB-TITLE1'.
  ELSE.
    CONCATENATE 'S_TAB-TITLE' W_TABSTRIP-ACTIVETAB+3 INTO LW_NAME.
  ENDIF.
  ASSIGN (LW_NAME) TO <FS>.
  IF SY-SUBRC NE 0.
    RETURN.
  ENDIF.

* Basic read query to check if first line is a comment
  CALL METHOD S_TAB_ACTIVE-O_TEXTEDIT->GET_TEXT
    IMPORTING
      TABLE  = LT_QUERY[]
    EXCEPTIONS
      OTHERS = 1.
  READ TABLE LT_QUERY INTO LS_QUERY INDEX 1.
  IF SY-SUBRC NE 0.
    <FS> = 'Empty tab'(m65).
    RETURN.
  ENDIF.
  IF LS_QUERY(1) = '*'.
    <FS> = LS_QUERY+1.
    RETURN.
  ENDIF.

* Query given, use it as title
  IF NOT FW_QUERY IS INITIAL.
    <FS> = FW_QUERY.
    RETURN.
  ENDIF.

* If no query given, try to read it
  PERFORM EDITOR_GET_QUERY USING SPACE CHANGING LW_QUERY LT_SELECT_TABLE.
  <FS> = LW_QUERY.

ENDFORM.                    " TAB_UPDATE_TITLE

*&---------------------------------------------------------------------*
*&      Form  Export_xml
*&---------------------------------------------------------------------*
*       Export Saved Queries in xml format
*----------------------------------------------------------------------*
FORM EXPORT_XML.
  DATA : BEGIN OF LS_XML,
           LINE(256) TYPE X,
         END OF LS_XML,
         LT_XML      LIKE TABLE OF LS_XML,

         LW_FILENAME TYPE STRING,
         LW_PATH     TYPE STRING,
         LW_FULLPATH TYPE STRING.
  DATA : LO_XML           TYPE REF TO IF_IXML,
         LO_DOCUMENT      TYPE REF TO IF_IXML_DOCUMENT,
         LO_ROOT          TYPE REF TO IF_IXML_ELEMENT,
         LO_ELEMENT       TYPE REF TO IF_IXML_ELEMENT,
         LW_STRING        TYPE STRING,
         LO_STREAMFACTORY TYPE REF TO IF_IXML_STREAM_FACTORY,
         LO_OSTREAM       TYPE REF TO IF_IXML_OSTREAM,
         LO_RENDERER      TYPE REF TO IF_IXML_RENDERER,
         LW_TITLE         TYPE STRING,
         LW_FILTER        TYPE STRING,
         LW_NAME          TYPE STRING,
         BEGIN OF LS_ZTOAD,
           QUERYID    TYPE ZTOAD-QUERYID,
           VISIBILITY TYPE ZTOAD-VISIBILITY_GROUP,
           TEXT       TYPE ZTOAD-TEXT,
           QUERY      TYPE ZTOAD-QUERY,
         END OF LS_ZTOAD,
         LT_ZTOAD LIKE TABLE OF LS_ZTOAD.

* Ask name of file to generate
  LW_TITLE = 'Choose file to create'(m57).
  LW_FILTER = 'XML File (*.xml)|*.xml'(m58).
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      WINDOW_TITLE = LW_TITLE
      FILE_FILTER  = LW_FILTER
    CHANGING
      PATH         = LW_PATH
      FILENAME     = LW_FILENAME
      FULLPATH     = LW_FULLPATH
    EXCEPTIONS
      OTHERS       = 1.
  IF SY-SUBRC NE 0 OR LW_FILENAME IS INITIAL OR LW_PATH IS INITIAL.
    MESSAGE 'Action cancelled'(m14) TYPE C_MSG_SUCCESS
            DISPLAY LIKE C_MSG_ERROR.
    RETURN.
  ENDIF.

  CONCATENATE SY-UNAME '#%' INTO LW_NAME.
  CONDENSE LW_NAME NO-GAPS.

* Get all saved query (but not history)
  SELECT QUERYID VISIBILITY TEXT QUERY
         INTO TABLE LT_ZTOAD
         FROM ZTOAD
         WHERE OWNER = SY-UNAME
         AND NOT QUERYID LIKE LW_NAME.

  LO_XML = CL_IXML=>CREATE( ).
  LO_DOCUMENT = LO_XML->CREATE_DOCUMENT( ).

  LO_ROOT  = LO_DOCUMENT->CREATE_SIMPLE_ELEMENT( NAME = C_XMLNODE_ROOT
                                                 PARENT = LO_DOCUMENT ).
  LOOP AT LT_ZTOAD INTO LS_ZTOAD.
    LO_ELEMENT  = LO_DOCUMENT->CREATE_SIMPLE_ELEMENT( NAME = C_XMLNODE_FILE
                                                      PARENT = LO_ROOT ).
    LW_STRING = LS_ZTOAD-VISIBILITY.
    LO_ELEMENT->SET_ATTRIBUTE( NAME = C_XMLATTR_VISIBILITY VALUE = LW_STRING ).

    LW_STRING = LS_ZTOAD-TEXT.
    LO_ELEMENT->SET_ATTRIBUTE( NAME = C_XMLATTR_TEXT VALUE = LW_STRING ).

    LW_STRING = LS_ZTOAD-QUERY.
    LO_ELEMENT->SET_VALUE( LW_STRING ).
  ENDLOOP.

  LO_STREAMFACTORY = LO_XML->CREATE_STREAM_FACTORY( ).

  LO_OSTREAM  = LO_STREAMFACTORY->CREATE_OSTREAM_ITABLE( LT_XML ).

  LO_RENDERER = LO_XML->CREATE_RENDERER( OSTREAM  = LO_OSTREAM
                                         DOCUMENT = LO_DOCUMENT ).
  LO_OSTREAM->SET_PRETTY_PRINT( ABAP_TRUE ).
  LO_RENDERER->RENDER( ).

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
    EXPORTING
      FILENAME = LW_FULLPATH
      FILETYPE = 'BIN'
    CHANGING
      DATA_TAB = LT_XML.
ENDFORM.                    "Export_xml

*&---------------------------------------------------------------------*
*&      Form  Import_xml
*&---------------------------------------------------------------------*
*       Import Saved Queries from xml format
*----------------------------------------------------------------------*
FORM IMPORT_XML.
  DATA : LT_FILETAB       TYPE FILETABLE,
         LS_FILE          TYPE FILE_TABLE,
         LW_FILENAME      TYPE STRING,
         LW_SUBRC         LIKE SY-SUBRC,
         LW_XMLDATA       TYPE XSTRING,
         LO_XML           TYPE REF TO IF_IXML,
         LO_DOCUMENT      TYPE REF TO IF_IXML_DOCUMENT,
         LO_STREAMFACTORY TYPE REF TO IF_IXML_STREAM_FACTORY,
         LO_STREAM        TYPE REF TO IF_IXML_ISTREAM,
         LO_PARSER        TYPE REF TO IF_IXML_PARSER.
  DATA : LO_ITERATOR  TYPE REF TO IF_IXML_NODE_ITERATOR,
         LO_NODE      TYPE REF TO IF_IXML_NODE,
         LW_NODE_NAME TYPE STRING,
         LO_ELEMENT   TYPE REF TO IF_IXML_ELEMENT,
         LW_TITLE     TYPE STRING,
         LW_FILTER    TYPE STRING,
         LW_GUID      TYPE GUID_32,
         LW_GROUP     TYPE USR02-CLASS,
         LW_STRING    TYPE STRING,
         LS_ZTOAD     TYPE ZTOAD,
         LT_ZTOAD     LIKE TABLE OF LS_ZTOAD.

* Choose file to import
  LW_TITLE = 'Choose file to import'(m59).
  LW_FILTER = 'XML File (*.xml)|*.xml'(m58).
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE   = LW_TITLE
      FILE_FILTER    = LW_FILTER
      MULTISELECTION = SPACE
    CHANGING
      FILE_TABLE     = LT_FILETAB
      RC             = LW_SUBRC.

* Check user action (1 OPEN, 2 CANCEL)
  IF LW_SUBRC NE 1.
    MESSAGE 'Action cancelled'(m14) TYPE C_MSG_SUCCESS
            DISPLAY LIKE C_MSG_ERROR.
    RETURN.
  ENDIF.

* Read filetable
  READ TABLE LT_FILETAB INTO LS_FILE INDEX 1.
  LW_FILENAME = LS_FILE-FILENAME.

* Get xml flow from file
* Or alternatively (if method does not exist) use the method
* cl_gui_frontend_services=>gui_upload and then convert the
* x-tab to xstring
  TRY.
      LW_XMLDATA = CL_OPENXML_HELPER=>LOAD_LOCAL_FILE( LW_FILENAME ).
    CATCH CX_OPENXML_NOT_FOUND.
      MESSAGE 'Error when opening the input XML file'(m60)
              TYPE C_MSG_ERROR.
      RETURN.
  ENDTRY.

  LO_XML = CL_IXML=>CREATE( ).

  LO_DOCUMENT = LO_XML->CREATE_DOCUMENT( ).
  LO_STREAMFACTORY = LO_XML->CREATE_STREAM_FACTORY( ).
  LO_STREAM = LO_STREAMFACTORY->CREATE_ISTREAM_XSTRING( STRING = LW_XMLDATA ).

  LO_PARSER = LO_XML->CREATE_PARSER( STREAM_FACTORY = LO_STREAMFACTORY
                                     ISTREAM        = LO_STREAM
                                     DOCUMENT       = LO_DOCUMENT ).
*-- parse the stream
  IF LO_PARSER->PARSE( ) NE 0.
    IF LO_PARSER->NUM_ERRORS( ) NE 0.
      MESSAGE 'Error when parsing the input XML file'(m61)
              TYPE C_MSG_ERROR.
      RETURN.
    ENDIF.
  ENDIF.

*-- we don't need the stream any more, so let's close it...
  CALL METHOD LO_STREAM->CLOSE( ).
  CLEAR LO_STREAM.

* Get usergroup
  SELECT SINGLE CLASS INTO LW_GROUP
         FROM USR02
         WHERE BNAME = SY-UNAME.

* Rebuild itab t_zspro
  LO_ITERATOR = LO_DOCUMENT->CREATE_ITERATOR( ).
  LO_NODE = LO_ITERATOR->GET_NEXT( ).
  WHILE NOT LO_NODE IS INITIAL.
    LW_NODE_NAME = LO_NODE->GET_NAME( ).
    IF LW_NODE_NAME = C_XMLNODE_FILE.
* Cast node to element
      LO_ELEMENT ?= LO_NODE. "->query_interface( ixml_iid_element ).
      CLEAR LS_ZTOAD.
      LS_ZTOAD-VISIBILITY_GROUP = LW_GROUP.
      LS_ZTOAD-OWNER = SY-UNAME.
      CONCATENATE SY-DATUM SY-UZEIT INTO LW_STRING.
      LS_ZTOAD-AEDAT = LW_STRING.

* Generate new GUID
      DO 100 TIMES.
* Old function to get an unique id
        CALL FUNCTION 'GUID_CREATE'
          IMPORTING
            EV_GUID_32 = LW_GUID.
* New function to get an unique id (do not work on older sap system)
*    TRY.
*        lw_guid = cl_system_uuid=>create_uuid_c32_static( ).
*      CATCH cx_uuid_error.
*        EXIT. "exit do
*    ENDTRY.

* Check that this uid is not already used
        SELECT SINGLE QUERYID INTO LS_ZTOAD-QUERYID
               FROM ZTOAD
               WHERE QUERYID = LW_GUID.
        IF SY-SUBRC NE 0.
          READ TABLE LT_ZTOAD WITH KEY QUERYID = LW_GUID TRANSPORTING NO FIELDS.
          IF SY-SUBRC NE 0.
            EXIT. "exit do
          ENDIF.
        ENDIF.
      ENDDO.
      LS_ZTOAD-QUERYID = LW_GUID.
      LW_STRING = LO_ELEMENT->GET_ATTRIBUTE( NAME = C_XMLATTR_VISIBILITY ).
      LS_ZTOAD-VISIBILITY = LW_STRING.
      LW_STRING = LO_ELEMENT->GET_ATTRIBUTE( NAME = C_XMLATTR_TEXT ).
      LS_ZTOAD-TEXT = LW_STRING.
      LW_STRING = LO_ELEMENT->GET_VALUE( ).
      LS_ZTOAD-QUERY = LW_STRING.
      APPEND LS_ZTOAD TO LT_ZTOAD.
    ENDIF.
    LO_NODE = LO_ITERATOR->GET_NEXT( ).
  ENDWHILE.

  INSERT ZTOAD FROM TABLE LT_ZTOAD.
  IF SY-SUBRC = 0.
    MESSAGE S031(R9). "Query saved
  ELSE.
    MESSAGE E220(IQAPI). "Error when saving the query
  ENDIF.

* Refresh repository to display new saved query
  PERFORM REPO_FILL.

ENDFORM.                    "import_xml

*&---------------------------------------------------------------------*
*&      Form  SET_STATUS_010
*&---------------------------------------------------------------------*
*       Set PF-STATUS for main scren
*       Adjust list of visible tabs
*----------------------------------------------------------------------*
FORM SET_STATUS_010 .
  DATA : LW_NUMB TYPE I,
         LW_MAX  TYPE I.

  AUTHORITY-CHECK OBJECT 'S_DEVELOP' ID 'ACTVT' FIELD '03'
                                     ID 'DEVCLASS' DUMMY
                                     ID 'OBJTYPE' DUMMY
                                     ID 'OBJNAME' DUMMY
                                     ID 'P_GROUP' DUMMY.
  IF SY-SUBRC = 0.
    SET PF-STATUS 'STATUS010'.
  ELSE.
* If you dont have S_DEVELOP access in display, you probably dont
* understand the code generated => do not display the button
    SET PF-STATUS 'STATUS010' EXCLUDING 'SHOWCODE'.
  ENDIF.
  SET TITLEBAR 'STATUS010'.

  DESCRIBE TABLE T_TABS LINES LW_MAX.

  LOOP AT SCREEN.
    IF SCREEN-NAME(6) = 'S_TAB-'.
      LW_NUMB = SCREEN-NAME+11.
      IF LW_NUMB > LW_MAX.
        SCREEN-INVISIBLE = 1.
      ELSE.
        SCREEN-INVISIBLE = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SET_STATUS_010

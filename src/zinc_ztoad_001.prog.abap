SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*INSERT1
SELECTION-SCREEN END OF BLOCK B1.

TYPES:BEGIN OF TY_DATA,
        SEL TYPE C,
*INSERT2
      END OF TY_DATA.
TYPES:BEGIN OF TY_ITEM.
TYPES: XZ         TYPE C,
       CURRENCY   LIKE EKPO-NETPR,
       CLR        TYPE CHAR4, "行颜色设置
       COLLCOLOR  TYPE LVC_T_SCOL, "单元格颜色
       BUTTON     TYPE ICON_D.
       INCLUDE TYPE TY_DATA.
       TYPES: CELLSTYLES TYPE  LVC_T_STYL. "单元格颜色(可编辑，按键等)
TYPES END OF TY_ITEM.

"EXCEL 操作相关对象
DATA: EXCEL       TYPE OLE2_OBJECT,
      WORKBOOK    TYPE OLE2_OBJECT,
      APPLICATION TYPE OLE2_OBJECT,
      SHEETS      TYPE OLE2_OBJECT,
      SHEET       TYPE OLE2_OBJECT,
      NEWSHEET    TYPE OLE2_OBJECT,
      CELL        TYPE OLE2_OBJECT,
      RANGE       TYPE OLE2_OBJECT,
      ROWS        TYPE OLE2_OBJECT.

DATA: IT_FIELDCAT TYPE  LVC_T_FCAT,
      WA_FIELDCAT TYPE  LVC_S_FCAT,
      WA_LAYOUT   TYPE LVC_S_LAYO,
      GT_SORT     TYPE SLIS_T_SORTINFO_ALV.

DATA:IT_ITEM TYPE STANDARD TABLE OF TY_ITEM,
     WA_ITEM LIKE LINE OF IT_ITEM.

DATA:CL_GRID TYPE REF TO CL_GUI_ALV_GRID.

DEFINE   MACRO_FILL_FCAT.
  CLEAR WA_FIELDCAT.
  &1 = &1 + 1.
  WA_FIELDCAT-COL_POS       = &1.
  WA_FIELDCAT-FIELDNAME     = &2.
  WA_FIELDCAT-SCRTEXT_L     = &3.
  WA_FIELDCAT-SCRTEXT_M     = &3.
  WA_FIELDCAT-SCRTEXT_S     = &3.
  WA_FIELDCAT-OUTPUTLEN     = &4.
  WA_FIELDCAT-EDIT          = &5. "
  WA_FIELDCAT-CHECKBOX      = &6.
  WA_FIELDCAT-EMPHASIZE     = &7. "列颜色设置
  WA_FIELDCAT-REF_TABLE     = &8.
  WA_FIELDCAT-REF_FIELD     = &9.
  WA_FIELDCAT-NO_ZERO       = 'X'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
END-OF-DEFINITION.

INITIALIZATION.
*  %_S_MATNR_%_APP_%-TEXT = '物料'.

START-OF-SELECTION.
  PERFORM FRM_GET_DATA.
  PERFORM FRM_PROCESS_DATA.

END-OF-SELECTION.
  PERFORM FRM_INIT_FIELDCAT.
  PERFORM FRM_INIT_LAYOUT.
* PERFORM FRM_ALV_OUTPUT.

FORM FRM_GET_DATA.
*INSERT3
ENDFORM.

FORM FRM_PROCESS_DATA.
ENDFORM.

FORM FRM_INIT_FIELDCAT .
  DATA: L_COLPOS TYPE LVC_S_FCAT-COL_POS.
*INSERT4
ENDFORM.

FORM FRM_INIT_LAYOUT .
  WA_LAYOUT-BOX_FNAME  = 'SEL'.
  WA_LAYOUT-CWIDTH_OPT = 'X'."优化列宽选项是否设置
  WA_LAYOUT-INFO_FNAME = 'CLR'."行颜色字段
  WA_LAYOUT-CTAB_FNAME = 'COLLCOLOR'."单元格颜色制单
  WA_LAYOUT-STYLEFNAME = 'CELLSTYLES'.
  WA_LAYOUT-ZEBRA      = 'X'."斑马线显示
ENDFORM.

FORM FRM_ALV_OUTPUT .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      I_CALLBACK_USER_COMMAND = 'FRM_USER_COMMAND'
*     I_CALLBACK_PF_STATUS_SET = 'FRM_SET_STATUS'
*     I_CALLBACK_TOP_OF_PAGE  = 'PRM_TOP_PAGE'
*     I_CALLBACK_HTML_END_OF_LIST = 'FRM_END_PAGE'
      IS_LAYOUT_LVC           = WA_LAYOUT
      IT_FIELDCAT_LVC         = IT_FIELDCAT[]
*     I_GRID_TITLE            = 'Test Report Title'
      I_DEFAULT               = 'X'
      I_SAVE                  = 'A'
    TABLES
      T_OUTTAB                = IT_ITEM
    EXCEPTIONS
      OTHERS                  = 2.
ENDFORM.

FORM  FRM_SET_STATUS USING PT_EXTAB TYPE SLIS_T_EXTAB  .
  DATA:WA_EXTAB LIKE LINE OF PT_EXTAB.
  "SE41  标准程序  SAPLKKBL  标准工具栏 STANDARD_FULLSCREEN
  WA_EXTAB-FCODE = '%SC+'.
  APPEND WA_EXTAB TO PT_EXTAB.
  SET PF-STATUS 'STANDARD_FULLSCREEN' EXCLUDING PT_EXTAB.
ENDFORM.

FORM FRM_USER_COMMAND USING R_UCOMM LIKE SY-UCOMM RS_SELFIELD TYPE SLIS_SELFIELD.
  IF CL_GRID IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        E_GRID = CL_GRID.
  ENDIF.
  CASE  R_UCOMM.
    WHEN '&IC1'.
      PERFORM FRM_EVENT_DBCLICK USING RS_SELFIELD-TABINDEX RS_SELFIELD-FIELDNAME.
    WHEN 'EXPORT'.
      PERFORM FRM_EVENT_EXPORT_EXCEL.
    WHEN 'PRINT'.
      PERFORM FRM_EVENT_PRINT.
    WHEN 'ALL'.
      PERFORM FRM_EVENT_ALL.
    WHEN 'SAL'.
      PERFORM FRM_EVENT_SAL.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

FORM FRM_ALV_REFRESH .
  CL_GRID->CHECK_CHANGED_DATA( ).
  DATA: STBL TYPE LVC_S_STBL.
  STBL-ROW = 'X'.
  STBL-COL = 'X'.
  CALL METHOD CL_GRID->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE = STBL.
ENDFORM.

"------------------------------------------------------------------------------file 操作。
FORM FRM_FILE_OPEN USING L_PATH_FULL.
  DATA:L_FILES TYPE FILETABLE,
       L_FILE  LIKE LINE OF L_FILES,
       L_RC    TYPE I.
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    EXPORTING
      WINDOW_TITLE = 'Select CSV file'
      FILE_FILTER  = '*.xls,*txt|*.xls;*.txt'
    CHANGING
      FILE_TABLE   = L_PATH_FULL
      RC           = L_RC.
  IF L_RC NE -1.
  ENDIF.
ENDFORM.

FORM FRM_FILE_SAVE USING L_PATH L_PATH_FULL L_FILENAME.
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      WINDOW_TITLE      = '标题'
      FILE_FILTER       = '*.xlsx|*.xls;'
      DEFAULT_EXTENSION = '.xls'
    CHANGING
      PATH              = L_PATH
      FULLPATH          = L_PATH_FULL
      FILENAME          = L_FILENAME.
ENDFORM.

FORM FRM_FILE_TEMPLATE_DOWNLOAD USING L_TEMPLATE_NAME L_PATH_FULL.
  DATA: LO_OBJDATA     LIKE WWWDATATAB,
        LS_DESTINATION TYPE RLGRAP-FILENAME,
        LI_RC          TYPE I.
  SELECT SINGLE RELID OBJID FROM WWWDATA INTO CORRESPONDING FIELDS OF LO_OBJDATA
  WHERE SRTF2 = 0 AND RELID = 'MI' AND OBJID = L_TEMPLATE_NAME.
  LS_DESTINATION = L_PATH_FULL.
  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
    EXPORTING
      KEY         = LO_OBJDATA
      DESTINATION = LS_DESTINATION
    IMPORTING
      RC          = LI_RC.
ENDFORM.
"------------------------------------------------------------------------------file 操作。

"------------------------------------------------------------------------------excel 操作。
FORM FRM_EXCEL_OPEN USING L_PATH_FULL.
  CREATE OBJECT EXCEL 'EXCEL.APPLICATION' .
  SET PROPERTY OF EXCEL 'VISIBLE' = 1 ."1 可见  2 不可见
  GET PROPERTY OF EXCEL 'WORKBOOKS' = WORKBOOK.
  CALL METHOD OF WORKBOOK 'OPEN'
    EXPORTING
      #1 = L_PATH_FULL.
  GET PROPERTY OF WORKBOOK 'APPLICATION' = APPLICATION.
  "指定 SHEET 并激活操作
  CALL METHOD OF APPLICATION 'WORKSHEETS' = SHEETS
      EXPORTING
       " #1 = 'SHEET3'."这里SHEET3为要操作的SHEET的名字。
        #1 = 1."也可以给1（当前文件）
  CALL METHOD OF SHEETS 'ACTIVATE '.
ENDFORM.

FORM FRM_EXCEL_FILL_DATA USING ROW COL VAL.
  CALL METHOD OF EXCEL 'CELLS' = CELL
    EXPORTING
      #1 = ROW
      #2 = COL.
  SET PROPERTY OF CELL 'VALUE' =  VAL .
ENDFORM.

FORM FRM_EXCEL_COYP USING ROW COL.
  CALL METHOD OF SHEET 'RANGE' = CELL
     EXPORTING
     #1 = ROW "A1
     #2 = COL."F12
  CALL METHOD OF CELL 'COPY'.
ENDFORM.

FORM FRM_EXCEL_PASTE USING ROW COL.
  CALL METHOD OF SHEET 'RANGE' = CELL
     EXPORTING
     #1 = ROW "A1
     #2 = COL."F12
  CALL METHOD OF SHEET 'PASTE'.
ENDFORM.

FORM FRM_EXCEL_INSERT USING ROW.
  CALL METHOD OF SHEET'ROWS' = ROWS
  EXPORTING
   #1          = ROW.
  CALL METHOD OF ROWS'INSERT'.
ENDFORM.

FORM FRM_EXCEL_SWITCH_SHEET USING SHEET.
  CALL METHOD OF APPLICATION 'WORKSHEETS' = SHEET
      EXPORTING
        #1 = SHEET."可以是1 表示第一个 也可以是sheet的名字
  CALL METHOD OF SHEET 'ACTIVATE '.
ENDFORM.

FORM FRM_EXCEL_QUIT .
  SET PROPERTY OF EXCEL 'SCREENUPDATING' = 1.
  GET PROPERTY OF EXCEL 'ACTIVEWORKBOOK' = WORKBOOK.
  CALL METHOD OF WORKBOOK 'SAVE'.
*CALL METHOD OF WORKBOOK 'CLOSE'.
*CALL METHOD OF EXCEL 'QUIT'.
**退出
*CALL METHOD OF APPLICATION 'QUIT'.
  FREE: EXCEL,WORKBOOK,APPLICATION,SHEETS,SHEET,NEWSHEET,CELL,RANGE,ROWS.
ENDFORM.

"------------------------------------------------------------------------------excel 操作。

"------------------------------------------------------------------------------event 操作。
FORM FRM_EVENT_DBCLICK  USING  L_TABINDEX L_FIELDNAME.
ENDFORM.

FORM FRM_EVENT_EXPORT_EXCEL .
  DATA:L_PATH      TYPE STRING,  L_PATH_FULL  TYPE STRING, L_FILENAME  TYPE STRING.
  PERFORM FRM_FILE_SAVE USING L_PATH  L_PATH_FULL L_FILENAME.
  IF L_PATH_FULL IS INITIAL.
    EXIT.
  ENDIF.
  PERFORM FRM_FILE_TEMPLATE_DOWNLOAD USING 'ZTEMPLATE' L_PATH_FULL.
  PERFORM FRM_EXCEL_OPEN USING L_PATH_FULL.
  LOOP AT IT_ITEM ASSIGNING  FIELD-SYMBOL(<WA_ITEM>).
    PERFORM FRM_EXCEL_FILL_DATA  USING SY-TABIX 1 'VALUE1'.
    PERFORM FRM_EXCEL_FILL_DATA USING SY-TABIX 2 'VALUE2'.
  ENDLOOP.
  PERFORM FRM_EXCEL_QUIT.
ENDFORM.

FORM FRM_EVENT_PRINT .
  DATA: FM_NAME TYPE FPNAME.
  DATA: CONTROL_PARAMETERS TYPE SSFCTRLOP.
  DATA: OUTPUT_OPTIONS     TYPE SSFCOMPOP.
  DATA: JOB_OUTPUT_OPTIONS TYPE SSFCRESOP,
        JOB_OUTPUT_INFO    TYPE SSFCRESCL.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME = 'ZPM005'
    IMPORTING
      FM_NAME  = FM_NAME.
  IF SY-SUBRC <> 0.
    MESSAGE '无法找到FUNCTION NAME' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  OUTPUT_OPTIONS-TDDEST        = 'LP01'.
  OUTPUT_OPTIONS-TDIMMED       = 'X'.
  OUTPUT_OPTIONS-TDCOPIES      = '1'.
  OUTPUT_OPTIONS-TDNOPRINT     = ''.
  OUTPUT_OPTIONS-TDDELETE      = 'X'.
  CONTROL_PARAMETERS-NO_DIALOG = ''.
  CONTROL_PARAMETERS-PREVIEW   = 'X'.
  CONTROL_PARAMETERS-LANGU     = SY-LANGU.

  LOOP AT IT_ITEM ASSIGNING FIELD-SYMBOL(<WA_ITEM>).
    CONTROL_PARAMETERS-NO_CLOSE  = 'X'. "添加新的打印任务，常见于多数据打印。‘X’激活此参数，实现多数据打印
    AT LAST.
      CONTROL_PARAMETERS-NO_CLOSE = SPACE.    "最后关闭假脱机请求 不再添加新数据，关闭该参数
    ENDAT.
    AT END OF SEL.
      CALL FUNCTION FM_NAME
        EXPORTING
          CONTROL_PARAMETERS = CONTROL_PARAMETERS
          OUTPUT_OPTIONS     = OUTPUT_OPTIONS
          USER_SETTINGS      = ''
          "WERKS              = ITAB-WERKS
        IMPORTING
          JOB_OUTPUT_OPTIONS = JOB_OUTPUT_OPTIONS
          JOB_OUTPUT_INFO    = JOB_OUTPUT_INFO
        EXCEPTIONS
          FORMATTING_ERROR   = 1
          INTERNAL_ERROR     = 2
          SEND_ERROR         = 3
          USER_CANCELED      = 4
          OTHERS             = 5.
      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 .
      ENDIF.
      CONTROL_PARAMETERS-NO_OPEN = 'X'."'X'激活此参数，不弹出预览Windows窗口
    ENDAT.
  ENDLOOP.
ENDFORM.

FORM FRM_EVENT_ALL .
  WA_ITEM-XZ = 'X'.
  MODIFY IT_ITEM FROM WA_ITEM TRANSPORTING XZ WHERE XZ = ''.
  PERFORM FRM_ALV_REFRESH.
ENDFORM.

FORM FRM_EVENT_SAL .
  WA_ITEM-XZ = ''.
  MODIFY IT_ITEM FROM WA_ITEM TRANSPORTING XZ WHERE XZ = 'X'.
  PERFORM FRM_ALV_REFRESH.
ENDFORM.
"-----------------------------------

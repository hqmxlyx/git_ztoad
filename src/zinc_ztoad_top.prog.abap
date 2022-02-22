*&---------------------------------------------------------------------*
*& 包含               ZINC_ZTOAD_TOP
*&---------------------------------------------------------------------*
* Global types
TYPES : BEGIN OF TY_FIELDLIST,
          FIELD     TYPE STRING,
          REF_TABLE TYPE STRING,
          REF_FIELD TYPE STRING,
        END OF TY_FIELDLIST,
        TY_FIELDLIST_TABLE TYPE STANDARD TABLE OF TY_FIELDLIST.

DATA:BEGIN OF LS_TABLE_ALIAS,
       TABLE TYPE CHAR50,
       ALIAS TYPE CHAR50,
     END OF LS_TABLE_ALIAS.


INCLUDE ZINC_ZTOAD_001.
INCLUDE ZINC_ZTOAD_002.

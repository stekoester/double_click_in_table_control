REPORT zkco_samples_dblclck_in_tblcon.

TABLES mara.

TYPES:
  BEGIN OF ty_mara,
    matnr TYPE mara-matnr,
    ersda TYPE mara-ersda,
    ernam TYPE mara-ernam,
    laeda TYPE mara-laeda,
    aenam TYPE mara-aenam,
    vpsta TYPE mara-vpsta,
    pstat TYPE mara-pstat,
    lvorm TYPE mara-lvorm,
  END OF ty_mara.

DATA gv_ucomm TYPE syucomm.
DATA gv_do_initialization TYPE char1.
DATA gv_field TYPE char128.
DATA gv_line TYPE systepl.

DATA gs_mara TYPE ty_mara.

DATA gt_mara TYPE TABLE OF ty_mara.

CONTROLS tc_mara TYPE TABLEVIEW USING SCREEN 0100.

CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  TEST_INIT  OUTPUT
*&---------------------------------------------------------------------*
MODULE tc_init OUTPUT.
  IF gv_do_initialization IS INITIAL.
    SELECT FROM mara
           FIELDS matnr, ersda, ernam, laeda, aenam, vpsta, pstat, lvorm
           INTO TABLE @gt_mara
           UP TO 100 ROWS.
    gv_do_initialization = abap_true.
    REFRESH CONTROL 'TC_MARA' FROM SCREEN '0100'.
  ENDIF.
  IF gv_line IS NOT INITIAL.
    SET CURSOR FIELD gv_field LINE gv_line.
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  TEST_MOVE  OUTPUT
*&---------------------------------------------------------------------*
MODULE test_move OUTPUT.
  MOVE-CORRESPONDING gs_mara TO mara.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA lv_itab_line TYPE i.
  DATA lv_matnr TYPE matnr.

  gv_ucomm = sy-ucomm.
  CLEAR sy-ucomm.
  CASE gv_ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE PROGRAM.
    WHEN 'MARA'.
      GET CURSOR FIELD gv_field LINE gv_line.
      CASE gv_field.
        WHEN 'MARA-MATNR'.
          gs_mara = VALUE #( gt_mara[ tc_mara-top_line + gv_line - 1 ] OPTIONAL ).
          IF gs_mara-matnr IS NOT INITIAL.
            SET PARAMETER ID 'MAT' FIELD gs_mara-matnr.
            CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
          ENDIF.
      ENDCASE.
  ENDCASE.
ENDMODULE.

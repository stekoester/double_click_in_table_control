PROCESS BEFORE OUTPUT.
  MODULE tc_init.

  LOOP AT gt_mara INTO gs_mara WITH CONTROL tc_mara
       CURSOR tc_mara-current_line.
    MODULE test_move.
  ENDLOOP.

  MODULE status_0100.

PROCESS AFTER INPUT.
  LOOP AT gt_mara.
  ENDLOOP.

  MODULE user_command_0100.

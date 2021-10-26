class ZCL_TCP_EVENT_HANDLER definition
  public
  final
  create public .

public section.

  interfaces IF_APC_WSP_EVENT_HANDLER .
  interfaces IF_APC_WSP_EVENT_HANDLER_BASE .
  interfaces ZIF_APC_WSP_EVENT_HANDLER .

  aliases MV_RESPONSE
    for ZIF_APC_WSP_EVENT_HANDLER~MV_RESPONSE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_TCP_EVENT_HANDLER IMPLEMENTATION.


  METHOD if_apc_wsp_event_handler~on_close.
    me->mv_response = 'Connection closed!'.
  ENDMETHOD.


  METHOD if_apc_wsp_event_handler~on_error.
  ENDMETHOD.


  METHOD if_apc_wsp_event_handler~on_message.
    TRY.
        me->mv_response = i_message->get_text( ).
        DATA(lv_len)    = strlen( me->mv_response ) - 1.
        me->mv_response = me->mv_response(lv_len).
      CATCH cx_apc_error INTO DATA(lx_apc_error).
        me->mv_response = lx_apc_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_apc_wsp_event_handler~on_open.
  ENDMETHOD.
ENDCLASS.

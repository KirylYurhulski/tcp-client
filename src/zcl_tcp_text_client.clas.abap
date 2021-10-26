class ZCL_TCP_TEXT_CLIENT definition
  public
  final
  create public .

public section.

  interfaces ZIF_TCP_CLIENT .

  methods CONSTRUCTOR
    importing
      !IO_EVENT_HANDLER type ref to ZIF_APC_WSP_EVENT_HANDLER
      !IV_HOST type STRING
      !IV_PORT type STRING .
protected section.
private section.

  data MO_EVENT_HANDLER type ref to ZIF_APC_WSP_EVENT_HANDLER .
  data MV_HOST type STRING .
  data MV_PORT type STRING .
  data MV_TERMINATOR type STRING value '0A' ##NO_TEXT.

  methods SEND
    importing
      !IO_CLIENT type ref to IF_APC_WSP_CLIENT
      !IV_REQUEST type STRING
    raising
      CX_APC_ERROR .
  methods RESPONSE
    returning
      value(RV_RESPONSE) type STRING
    raising
      CX_APC_ERROR .
ENDCLASS.



CLASS ZCL_TCP_TEXT_CLIENT IMPLEMENTATION.


  METHOD constructor.
    me->mo_event_handler = io_event_handler.
    me->mv_host          = iv_host.
    me->mv_port          = iv_port.
  ENDMETHOD.


  METHOD response.
    CLEAR:  me->mo_event_handler->mv_response.

    WAIT FOR PUSH CHANNELS UNTIL me->mo_event_handler->mv_response IS NOT INITIAL UP TO 10 SECONDS.
    CASE sy-subrc.
      WHEN 4.
        RAISE EXCEPTION TYPE cx_apc_error
          EXPORTING
            error_text = 'No handler for APC messages registered!'.
      WHEN 8.
        RAISE EXCEPTION TYPE cx_apc_error
          EXPORTING
            error_text = 'Timeout occured!'.
    ENDCASE.

   rv_response = me->mo_event_handler->mv_response.
  ENDMETHOD.


  METHOD send.
    DATA(lo_content_manager)    = CAST if_apc_wsp_message_manager( io_client->get_message_manager( ) ).
    DATA(lo_content)            = CAST if_apc_wsp_message( lo_content_manager->create_message( ) ).
    DATA(lv_binary_terminator)  = CONV xstring( mv_terminator ).
    DATA(lv_binary_msg)         = cl_abap_codepage=>convert_to( iv_request ).

    CONCATENATE lv_binary_msg lv_binary_terminator
      INTO lv_binary_msg IN BYTE MODE.
    lo_content->set_binary( lv_binary_msg ).
    lo_content_manager->send( lo_content ).
  ENDMETHOD.


  METHOD zif_tcp_client~start.
    DATA(lo_client) = cl_apc_tcp_client_manager=>create(
      EXPORTING
        i_host          = me->mv_host
        i_port          = me->mv_port
        i_frame         = VALUE apc_tcp_frame( frame_type = if_apc_tcp_frame_types=>co_frame_type_terminator
                                               terminator = mv_terminator )
        i_event_handler = me->mo_event_handler
    ).
    lo_client->connect( ).
    me->send(
      EXPORTING
        io_client  = lo_client
        iv_request = iv_request
    ).
    rv_response = me->response( ).
    lo_client->close( 'Application closed connection!' ).
  ENDMETHOD.
ENDCLASS.

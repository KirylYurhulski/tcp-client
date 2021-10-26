*&---------------------------------------------------------------------*
*& Report ZTCP_CLIENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztcp_client.

PARAMETERS: p_host TYPE string OBLIGATORY,
            p_port TYPE string OBLIGATORY DEFAULT '8000',
            p_req  TYPE string OBLIGATORY DEFAULT 'Say Hello, TCP!' LOWER CASE.

INITIALIZATION.
  p_host = cl_gui_frontend_services=>get_ip_address( ).

START-OF-SELECTION.
  TRY.
      DATA(lv_response) = NEW zcl_tcp_text_client(
        io_event_handler = NEW zcl_tcp_event_handler( )
        iv_host          = p_host
        iv_port          = p_port
      )->zif_tcp_client~start( p_req ).
      WRITE: |RESPONSE: { lv_response }|.
    CATCH cx_apc_error INTO DATA(lx_apc_error).
      WRITE:  |ERROR: { lx_apc_error->get_text( ) }|.
  ENDTRY.

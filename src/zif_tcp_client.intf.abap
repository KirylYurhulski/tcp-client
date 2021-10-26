interface ZIF_TCP_CLIENT
  public .


  methods START
    importing
      !IV_REQUEST type STRING
    returning
      value(RV_RESPONSE) type STRING
    raising
      CX_APC_ERROR .
endinterface.

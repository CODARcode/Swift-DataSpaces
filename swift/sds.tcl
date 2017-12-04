
# SDS TCL

# Initialization function to be called by Turbine
proc sds_init_tcl { } {
  # Duplicate the ADLB communicator
  set dup [ adlb::comm_dup [ adlb::comm_get adlb ] ]
  # Pass the new communicator to sds_init()
  set rc [ sds_init $dup 1 ]
  check { $rc == 0 } "sds_init failed!"
}

# Tell Turbine to initialize this module
lappend turbine_init_cmds "sds_init_tcl"

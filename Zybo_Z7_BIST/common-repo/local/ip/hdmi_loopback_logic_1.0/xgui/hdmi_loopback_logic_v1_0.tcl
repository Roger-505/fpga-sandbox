# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set_property tooltip {Page 0} ${Page_0}
  #Adding Group
  set sdf [ipgui::add_group $IPINST -name "sdf" -parent ${Page_0} -display_name {HDMI Settings}]
  set kCECIntLoopback [ipgui::add_param $IPINST -name "kCECIntLoopback" -parent ${sdf}]
  set_property tooltip {If CEC Rx is not available, loop back CEC Tx internally} ${kCECIntLoopback}
  ipgui::add_param $IPINST -name "kHPDInverted" -parent ${sdf}

  #Adding Group
  set AXI-L_Settings [ipgui::add_group $IPINST -name "AXI-L Settings" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_S_AXI_HIGHADDR" -parent ${AXI-L_Settings}
  ipgui::add_param $IPINST -name "C_S_AXI_BASEADDR" -parent ${AXI-L_Settings}
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${AXI-L_Settings}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${AXI-L_Settings}



}

proc update_PARAM_VALUE.kCECIntLoopback { PARAM_VALUE.kCECIntLoopback } {
	# Procedure called to update kCECIntLoopback when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kCECIntLoopback { PARAM_VALUE.kCECIntLoopback } {
	# Procedure called to validate kCECIntLoopback
	return true
}

proc update_PARAM_VALUE.kHPDInverted { PARAM_VALUE.kHPDInverted } {
	# Procedure called to update kHPDInverted when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kHPDInverted { PARAM_VALUE.kHPDInverted } {
	# Procedure called to validate kHPDInverted
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to update C_S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to validate C_S_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.kHPDInverted { MODELPARAM_VALUE.kHPDInverted PARAM_VALUE.kHPDInverted } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kHPDInverted}] ${MODELPARAM_VALUE.kHPDInverted}
}

proc update_MODELPARAM_VALUE.kCECIntLoopback { MODELPARAM_VALUE.kCECIntLoopback PARAM_VALUE.kCECIntLoopback } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kCECIntLoopback}] ${MODELPARAM_VALUE.kCECIntLoopback}
}


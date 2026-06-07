# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set kHorActive [ipgui::add_param $IPINST -name "kHorActive" -parent ${Page_0}]
  set_property tooltip {(in number of pixels)} ${kHorActive}
  set kVerActive [ipgui::add_param $IPINST -name "kVerActive" -parent ${Page_0}]
  set_property tooltip {(in number of lines)} ${kVerActive}
  ipgui::add_param $IPINST -name "kMaxResolution" -parent ${Page_0}


}

proc update_PARAM_VALUE.kHorActive { PARAM_VALUE.kHorActive } {
	# Procedure called to update kHorActive when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kHorActive { PARAM_VALUE.kHorActive } {
	# Procedure called to validate kHorActive
	return true
}

proc update_PARAM_VALUE.kMaxResolution { PARAM_VALUE.kMaxResolution } {
	# Procedure called to update kMaxResolution when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kMaxResolution { PARAM_VALUE.kMaxResolution } {
	# Procedure called to validate kMaxResolution
	return true
}

proc update_PARAM_VALUE.kVerActive { PARAM_VALUE.kVerActive } {
	# Procedure called to update kVerActive when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kVerActive { PARAM_VALUE.kVerActive } {
	# Procedure called to validate kVerActive
	return true
}


proc update_MODELPARAM_VALUE.kMaxResolution { MODELPARAM_VALUE.kMaxResolution PARAM_VALUE.kMaxResolution } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kMaxResolution}] ${MODELPARAM_VALUE.kMaxResolution}
}

proc update_MODELPARAM_VALUE.kHorActive { MODELPARAM_VALUE.kHorActive PARAM_VALUE.kHorActive } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kHorActive}] ${MODELPARAM_VALUE.kHorActive}
}

proc update_MODELPARAM_VALUE.kVerActive { MODELPARAM_VALUE.kVerActive PARAM_VALUE.kVerActive } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kVerActive}] ${MODELPARAM_VALUE.kVerActive}
}


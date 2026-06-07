# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set LEDS [ipgui::add_param $IPINST -name "LEDS" -parent ${Page_0} -widget comboBox]
  set_property tooltip {The number of leds} ${LEDS}
  set PROCENT [ipgui::add_param $IPINST -name "PROCENT" -parent ${Page_0} -widget comboBox]
  set_property tooltip {PWM Procent} ${PROCENT}
  set STEP [ipgui::add_param $IPINST -name "STEP" -parent ${Page_0} -widget comboBox]
  set_property tooltip {How fast the intensity will increase} ${STEP}
  set TIME_TO_DISPLAY [ipgui::add_param $IPINST -name "TIME_TO_DISPLAY" -parent ${Page_0} -widget comboBox]
  set_property tooltip {The amount of time a intensity is displayed} ${TIME_TO_DISPLAY}


}

proc update_PARAM_VALUE.LEDS { PARAM_VALUE.LEDS } {
	# Procedure called to update LEDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LEDS { PARAM_VALUE.LEDS } {
	# Procedure called to validate LEDS
	return true
}

proc update_PARAM_VALUE.PROCENT { PARAM_VALUE.PROCENT } {
	# Procedure called to update PROCENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROCENT { PARAM_VALUE.PROCENT } {
	# Procedure called to validate PROCENT
	return true
}

proc update_PARAM_VALUE.STEP { PARAM_VALUE.STEP } {
	# Procedure called to update STEP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STEP { PARAM_VALUE.STEP } {
	# Procedure called to validate STEP
	return true
}

proc update_PARAM_VALUE.TIME_TO_DISPLAY { PARAM_VALUE.TIME_TO_DISPLAY } {
	# Procedure called to update TIME_TO_DISPLAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIME_TO_DISPLAY { PARAM_VALUE.TIME_TO_DISPLAY } {
	# Procedure called to validate TIME_TO_DISPLAY
	return true
}


proc update_MODELPARAM_VALUE.LEDS { MODELPARAM_VALUE.LEDS PARAM_VALUE.LEDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LEDS}] ${MODELPARAM_VALUE.LEDS}
}

proc update_MODELPARAM_VALUE.PROCENT { MODELPARAM_VALUE.PROCENT PARAM_VALUE.PROCENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROCENT}] ${MODELPARAM_VALUE.PROCENT}
}

proc update_MODELPARAM_VALUE.STEP { MODELPARAM_VALUE.STEP PARAM_VALUE.STEP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STEP}] ${MODELPARAM_VALUE.STEP}
}

proc update_MODELPARAM_VALUE.TIME_TO_DISPLAY { MODELPARAM_VALUE.TIME_TO_DISPLAY PARAM_VALUE.TIME_TO_DISPLAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIME_TO_DISPLAY}] ${MODELPARAM_VALUE.TIME_TO_DISPLAY}
}


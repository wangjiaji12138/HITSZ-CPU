# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/220110630/proj_single_cycle/proj_single_cycle.cache/wt [current_project]
set_property parent.project_path D:/220110630/proj_single_cycle/proj_single_cycle.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/220110630/proj_single_cycle/proj_single_cycle.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files d:/220110630/proj_single_cycle/hex3.coe
add_files d:/220110630/proj_single_cycle/hex33.coe
read_verilog {
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/param.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/defines.vh
}
set_property file_type "Verilog Header" [get_files D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/param.v]
set_property is_global_include true [get_files D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/param.v]
read_verilog -library xil_defaultlib {
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/ALU.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/Bridge.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/Button_Interface.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/Ctrl.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/DIGIT.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/DLED_Interface.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/Dig.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/LED_Interface.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/NPC.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/PC.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/RF.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/SEXT.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/Switches_Interface.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/myCPU.v
  D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/new/miniRV_SoC.v
}
read_ip -quiet D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all d:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all d:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all d:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

read_ip -quiet D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/DRAM/DRAM.xci
set_property used_in_implementation false [get_files -all d:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/DRAM/DRAM_ooc.xdc]

read_ip -quiet D:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/IROM/IROM.xci
set_property used_in_implementation false [get_files -all d:/220110630/proj_single_cycle/proj_single_cycle.srcs/sources_1/ip/IROM/IROM_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/220110630/proj_single_cycle/proj_single_cycle.srcs/constrs_1/new/miniRV_clock.xdc
set_property used_in_implementation false [get_files D:/220110630/proj_single_cycle/proj_single_cycle.srcs/constrs_1/new/miniRV_clock.xdc]

read_xdc D:/220110630/proj_single_cycle/proj_single_cycle.srcs/constrs_1/new/miniRV_SoC.xdc
set_property used_in_implementation false [get_files D:/220110630/proj_single_cycle/proj_single_cycle.srcs/constrs_1/new/miniRV_SoC.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top miniRV_SoC -part xc7a100tfgg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef miniRV_SoC.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file miniRV_SoC_utilization_synth.rpt -pb miniRV_SoC_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]

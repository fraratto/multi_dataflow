#Lo script va lanciato dalla cartella multi_dataflow

#set variables
set prj_dir "../prj_dir"
set prj_name "test_script"
set partname "xc7a50tcsg324-2"

#create project
create_project $prj_name $prj_dir -part $partname

#add source files
add_files -norecurse {./src/fifo/FIFO_MS.v ./src/actors/SDF_1P_2F.v}
update_compile_order -fileset sources_1

#add sim files
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ./src/tb/tb_fifo_ms_sdf_2f.v
update_compile_order -fileset sim_1

#run simulation
launch_simulation
source $prj_dir/test_script.sim/sim_1/behav/xsim/tb_fifo_ms_sdf_2f.tcl
close_sim

#close project
close_project
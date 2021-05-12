#Lo script va lanciato dalla cartella multi_dataflow

#set variables
set prj_name "test_hevc_sr"
set prj_dir "./prj_dir/$prj_name"
set partname "xc7a50tcsg324-2"

#create project
create_project $prj_name $prj_dir -part $partname

#add source files
set src_dir "./src/hevc"

	#actors
	add_files -norecurse "$src_dir/remove_h_border.sv $src_dir/adder_18.sv $src_dir/coeff_luma_8tap.sv $src_dir/delayer.sv $src_dir/derive_real_size_8tap.sv $src_dir/adder_27.sv $src_dir/shifter.sv $src_dir/multiplier_18.sv $src_dir/remove_v_border.sv $src_dir/line_buffer.sv $src_dir/clipper.sv $src_dir/multiplier_9.sv"

	#top
	add_files -norecurse $src_dir/top_sr.sv

	#fifo
	add_files -norecurse {./src/fifo/fifo_sr.sv}

#add sim files
set tb_dir "./src/tb/test_hevc"
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse "$tb_dir/tb_hevc_sr_2f.sv $tb_dir/input_16x16.mem $tb_dir/output_16x16_v2_h2.mem"


set repo_dir "/home/shaun/repos/nexys_video_gpio"
set ip_dir "$repo_dir/ip"
set xci_name "axi_vip_0_lite_master.xci"

if ([file exists ../$ip_dir/$xci_name]) {
  read_ip ../$ip_dir/$xci_name
} else {
  create_ip \
    -name axi_vip \
    -vendor xilinx.com \
    -library ip \
    -version 1.1 \
    -module_name $xci_name

  set_property -dict [list \
    CONFIG.ADDR_WIDTH {64} \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.INTERFACE_MODE {MASTER} \
    CONFIG.PROTOCOL {AXI4LITE} \
  ] [get_ips $xci_name]

  generate_target all [get_ips]
}

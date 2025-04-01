## Zybo Z7 Constraints File (Fixed)

## PS/2 Clock and Data Pins (PMOD JC)
set_property PACKAGE_PIN V15 [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ps2_clk]

set_property PACKAGE_PIN W15 [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]

## Reset Button (BTNC)
set_property PACKAGE_PIN Y16 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PULLTYPE PULLUP [get_ports rst]

## ASCII Output to LEDs (LD0 to LD7)
set_property PACKAGE_PIN U14 [get_ports {ascii[0]}]
set_property PACKAGE_PIN U15 [get_ports {ascii[1]}]
set_property PACKAGE_PIN V17 [get_ports {ascii[2]}]
set_property PACKAGE_PIN V18 [get_ports {ascii[3]}]
set_property PACKAGE_PIN V13 [get_ports {ascii[4]}]
set_property PACKAGE_PIN U17 [get_ports {ascii[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ascii[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {comand[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {comand[0]}]

set_property PACKAGE_PIN M15 [get_ports {comand[1]}]
set_property PACKAGE_PIN M14 [get_ports {comand[0]}]

set_property PACKAGE_PIN T17 [get_ports {ascii[6]}]
set_property PACKAGE_PIN Y17 [get_ports {ascii[7]}]

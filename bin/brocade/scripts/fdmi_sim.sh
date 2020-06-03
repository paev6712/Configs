#!/bin/sh
# File: fdmi_sim.sh
# Set up simulation ports on edsim for FDMI.

# Define edsim ports to use
# port_list=(8 9 10 11) #12 13 14 15 16 17 18 19 20 21 22 23)
port_list=(24)

# Define number of ports to generate
num_ports=2

echo "Begin looping through ports" ${port_list[*]}
# Loop through ports 
for i in ${port_list[@]}; do
	# Stop the current simulation (if any)
	echo "Stop port" $i
	dsim --portstop $i

	# Start the new simulation
	echo "Start port" $i "," ${num_ports} "ports"
	dsim --portstart $i $num_ports fdmi_host

	# Wait for it to process
	sleep 30;
done


exit 0

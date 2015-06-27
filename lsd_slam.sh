#!/bin/bash

if [ $# -lt 1 ]; then
	echo -e "$(tput bold) usage: lsd_slam.sh <param> $(tput sgr 0)"
	echo -e "\t <param> = 0 (run with own camera) $(tput sgr 0)"
	echo -e "\t <param> = 1 (run with bag file) $(tput sgr 0)"
	exit
fi

echo -e "$(tput bold) $(tput setaf 1) source workspace $(tput sgr 0) \t ~/catkin_ws/devel/"
source ~/catkin_ws/devel/setup.bash

echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t ros core"
gnome-terminal -e '/bin/bash -c "roscore" '   

sleep 2

if [ $1 = 1 ]; then

	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t slam viewer"
	gnome-terminal -e '/bin/bash -c "rosrun lsd_slam_viewer viewer" '

	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t slam core"
	gnome-terminal -e '/bin/bash -c "rosrun lsd_slam_core live_slam image:=/image_raw camera_info:=/camera_info" '

	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t bag file"
	gnome-terminal -e '/bin/bash -c "rosbag play ~/catkin_ws/bag/LSD_room.bag" '
else
	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t camera"
	gnome-terminal -e '/bin/bash -c "rosrun usb_cam usb_cam_node _video_device:="/dev/video1" _camera_info_url:="" " '

	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t slam code"
	gnome-terminal -e '/bin/bash -c "rosrun lsd_slam_core live_slam /image:=/usb_cam/image_raw _calib:="/home/markus/repositories/cameraCalibration/creative_webcam_fov_in.cfg" " '


	echo -e "$(tput bold) $(tput setaf 1) open terminal $(tput sgr 0) \t slam viewer"
	gnome-terminal -e '/bin/bash -c "rosrun lsd_slam_viewer viewer " '
fi

read -n1 -r -p "Press space to continue..." key

killall viewer
killall live_slam
killall rosbag
killall usb_cam
killall roscore


rosrun lsd_slam_core live_slam /image:=<yourstreamtopic> /camera_info:=<yourcamera_infotopic>
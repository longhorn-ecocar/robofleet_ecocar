# make sure to escape newlines
MSG_TYPES=\
	amrl_msgs/RobofleetStatus\
	amrl_msgs/RobofleetSubscription\
	amrl_msgs/ElevatorStatus\
	amrl_msgs/ElevatorCommand\
	amrl_msgs/ErrorReport\
	amrl_msgs/Localization2DMsg\
	amrl_msgs/SensorStatus\
	amrl_msgs/SensorHealth\
	amrl_msgs/SystemHealth\
	amrl_msgs/SystemLog\
	amrl_msgs/CACCStatus\
	amrl_msgs/VisualizationMsg\
	sensor_msgs/NavSatFix\
	sensor_msgs/LaserScan\
	sensor_msgs/CompressedImage\
	sensor_msgs/PointCloud2\
	std_msgs/String\
	std_msgs/ByteMultiArray\
	geometry_msgs/PoseStamped\
	geometry_msgs/PoseWithCovarianceStamped\
	nav_msgs/Odometry\
# this line intentionally left blank

# change this if your ROS install uses python 3
PYTHON?=/usr/bin/python3

# if you have flatbuffers installed, you can change this path
FLATC?=build/flatbuffers/flatc

.SUFFIXES: # disable default rules

.PHONY: all
all: update_schemas

.PHONY: clean
clean:
	-rm -f *_generated.*
	-rm -f schema.fbs
	-rm -rf build

.PHONY: update_schemas
update_schemas: schema_generated.h schema_generated.ts
	cp schema_generated.h ../robofleet_client/robofleet_client_lib/include
	cp schema_generated.ts ../robofleet_server/src
	cp schema_generated.ts ../robofleet_webviz/src

.PHONY: schema.fbs # always rebuild in case message types change
schema.fbs:
	$(PYTHON) msg2fbs.py -e -o schema.fbs $(MSG_TYPES)

schema_generated.h: schema.fbs $(FLATC)
	$(FLATC) --gen-object-api --no-fb-import -c schema.fbs

schema_generated.ts: schema.fbs $(FLATC)
	$(FLATC) --no-fb-import -T schema.fbs

build/flatbuffers/flatc: build/flatbuffers/Makefile
	(cd build/flatbuffers; make -j flatc)

build/flatbuffers/Makefile: flatbuffers/CMakeLists.txt
	mkdir -p build/flatbuffers
	(cd build/flatbuffers; cmake ../../flatbuffers)

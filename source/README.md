== SvE Sequencer, DPF version ==

This plugin is a simple sequencer plugin made with DPF.
DPF is a C++ plugin framework that supports LV2.

LV2 plugins are defined in two parts: code and data.
With DPF the plugin code is written in C++ and LV2 data is automatically generated for you.

Use this to install from ~/mod-workdir/moddwarf/plugins to moddwarf
tar cz DPF-Sequencer.lv2 | base64 | curl -F 'package=@-' http://192.168.51.1/sdk/install

Run this command from ~/mod-plugin-builder dir to build plugins
./build moddwarf sve-sequencer-dpf-labs

Run this to enable logging in MOD Device
systemctl stop jack2; MOD_LOG=1 mod-jackd

TODO:
- add ping to bash script to check if MOD Device is connected before installing plugin
    * ping -c 1 192.168.51.1 > /dev/null
- split code in different classes:
    * sequencerPlugin
    * euclideanSequencer
    * ringBuffer
    * clock
    * generator
    * track
- change uints to smaller byte sizes where needed
- change name of plugin.cpp/hpp to sequencerPlugin.cpp/hpp or myPlugin.cpp/hpp?
- make variables const that won't change
- add reverse toggle + implementation
- send noteOff to all pitches when plugin is deleted

Big thanks to Bram Giessen and Jan Janssen for helping with this project.

cmake_minimum_required(VERSION 3.7)
 project(sve-test)

 add_subdirectory(dpf)

 dpf_add_plugin(test
   TARGETS clap lv2 vst2 vst3

   FILES_DSP
       source/test.cpp
 )

 target_include_directories(sve-test
   PUBLIC source)

 target_compile_options(sve-test PUBLIC "-Wno-c++11-narrowing")

 add_compile_options(-fdiagnostics-color=always)
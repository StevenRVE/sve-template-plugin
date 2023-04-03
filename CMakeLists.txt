cmake_minimum_required(VERSION 3.7)
 project(sve-template-plugin)

 add_subdirectory(dpf)

 dpf_add_plugin(sve-template-plugin
   TARGETS clap lv2 vst2 vst3

   FILES_DSP
       source/template-plugin.cpp
 )

 target_include_directories(sve-template-plugin
   PUBLIC source)

 target_compile_options(sve-template-plugin PUBLIC "-Wno-c++11-narrowing")

 add_compile_options(-fdiagnostics-color=always)

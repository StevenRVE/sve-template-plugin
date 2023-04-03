# sve-template-plugin
This repository contains a template plugin for building plugins using the DPF framework.

Clone git repository
```
git clone git@github.com:StevenRVE/sve-template-plugin.git
```

Add DPF as git submodule
```
cd sve-template-plugin

git submodule add -b develop --name dpf git@github.com:DISTRHO/DPF.git dpf
git submodule update --init --recursive

cd dpf
git pull
```

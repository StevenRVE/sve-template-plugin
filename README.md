# sve-templatePlugin
This repository contains a template plugin for building plugins using the DPF framework.

Clone git repository
```
git clone git@github.com:StevenRVE/sve-template-plugin.git
```

Add DPF as git submodule
```
cd sve-templatePlugin

git submodule init
git submodule update --recursive

cd dpf
git pull origin develop
```

If something is wrong with adding dpf, remove the submodule following the steps described here: https://gist.github.com/myusuf3/7f645819ded92bda6677#:~:text=To%20remove%20a,upvote%20this%20answer

## Generate new plugin from template

```
cd source

python generateNewPlugin.py
```

Enter name and URI in terminal
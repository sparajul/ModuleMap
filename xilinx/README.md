# Xilinx FPGA Code repository

Add your development as sub-repository or start your development under the correct L4 area.
If you have doubts reagarding the L4 area, please let us know.

# Work with the Gitlab repo
## Clone the repo

Clone the repository on your local machine

```
ssh://git@gitlab.cern.ch:7999/atlas-tdaq-ph2upgrades/atlas-tdaq-eftracking/eftracking_fpga_dev/fpga/xilinx.git
```

## Create and push a new branch

Create your own development branch, giving it a meaningful name (don't use your own name or Cern username).
Suggestion: use the name of the development you are working on.

Create a new branch, e.g.:

```
git checkout -b 1DBitshift
```

Push the new branch, e.g.:

```
git push -u origin 1DBitshift
```

Master is protected, open a merge request to merge into master.

When a development is tested and needs to be included in master, please open a merge request and assign it to one of the repository manintainers:

- Paolo Mastrandrea
- Priya Sundararajan
- Alessandra Camplani

## Gitlab commands

More information about gitlab command can be found [in these notes](https://heterogeneous-tools-notes.docs.cern.ch/Gitlab_Info/Gitlab_tech/).


# Move your firmware project

## How to push a project
To import a new project on Gitlab there are various possibilities.

You can add your files, one by one, to the repository and work directly on it to version control it.
Or, if you have already a gitlab repository where you wish to continue working, you could push it as submodule.

[At this link](https://heterogeneous-tools-notes.docs.cern.ch/Gitlab_Info/IDE_project/) you can find the instruction for both types of push for Xilinx Vivado and Intel Quartus projects.

More information will be provided for what concern Vitis and OneAPI projects.



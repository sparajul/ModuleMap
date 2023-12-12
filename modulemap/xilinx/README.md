# Xilinx FPGA Code repository

Add your development as sub-repository or start your development under the correct L4 area.
If you have doubts reagarding the L4 area, please let us know.

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

## Add new files to your repo

Check the status of the status of your development with the command:

```
git status
```

This will tell you which files you have modified and which ones are untracked (not part of the repository but present in your folders).

You can check what has changed in your file typing:

```
git diff name_of_the_file
```

To include files in you repo you need to perform three step: add, commit and push.

The first command "add", allows you to add your files to the staging area. It tells Git that you want to include updates to a particular file in the next commit.

```
git add
```

The commmand commit is used to save your changes to the local repository. It's important to include a meaningful message (or eventually a ijra number in you commit).

```
git commit -m 'Solved counting bug, confirmed with simulation
```

Finally the git push command is used to upload local repository content to a remote repository, in your development branch.

```
git push
```

## Switching and mergeing branches

If you have multiple development branches you can switch betwenn them with the command:

```
git checkout name_of_the_other_branch
```

In this case don't add `-b` or it will create a new branch.

You can merge development branches. If you are working on branch_1, but you want to include the development made in branch_2, you should first make sure that you are on branch_1.

Check with `git status`, and in case you are not on the correct branch you can type:

```
git checkout branch_1
```

The type: 

```
git merge branch_2
```

Marges could be tricky, as you might have conflicts between files. It's recommended to use a tool that provide a GUI (e.g. you can [donwload Meld](https://meldmerge.org/)) and follow the [documentation provided by git](https://git-scm.com/docs/git-mergetool) to set it up.

## Pushing to master

Master is protected, open a merge request to merge into master.

When a development is tested and needs to be included in master, please open a merge request and assign it to one of the repository manintainers:

- Paolo Mastrandrea
- Priya Sundararajan
- Alessandra Camplani

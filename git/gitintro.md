# Ian's Intro to Git 

A very good and also maintained introduction: https://www.atlassian.com/git/tutorials/

# FAQs from the wild (work):

## What are commits? 

Commits are collections of file diffs (aka file comparisons). Any time a file is created or modified, a file difference is created, and this difference can be added to a commit. Basic `git` usage is as simple as deciding which file changes to add to each commit and then making a series of commits.  

An important feature of commits is that only file changes are tracked. So, creating a directory is not a change according to git. However, creating a directory with an empty file inside is a change that can be committed. 
    
A subtle but important feature of commits is that they store both file differences as well as file __state__. So, if a git user wants to see what a repository/file looked like at a certain point in time (e.g., prior to a big codebase refactoring), they can find the appropriate commit in the comit history and view exactly how everything looked at the time of that commit. 

## What's the purpose of the staging area? Why is `git add` necessary?

Beginner git usage typically involves adding every file in the staging area and then making a commit. This usually looks like:
```bash
# make some changes
git add .
git commit -m "my changes"
# make more changes
git add .
git commit -m "misguided commit message"
```
However, once a project becomes more complicated, changes are typically grouped into commits based on the type of change. This is where the staging area becomes important. For example, a git user could have made changes to 10 files, but choose only 5 of them to group into the commit. 

Advantages of this approach include:  
  1. Helps others understand commit history because similar changes are grouped into commits with (hopefully) explanatory commit messages
  2. Facilitates removing or altering single commits after-the-fact since

Examples of where this might be useful:
   - Making a series of minor administrative changes (e.g., updating version numbers)
   - Restructuring a repository directory

## What is a git branch?

A git branch is simply a logical collection of git commits. Each new git repository is configured with a default branch named `master`. A basic git project can hum along just fine using only one branch.  

However, once projects become complicated or multiple are involved, it becomes much harder to share a single branch. Basic examples where branches are useful:  

  - 2 developers are working on an application and are developing separate features. Each feature could (probably should) have its own devoted branch
  - A machine learning engineer wants to separate their data processing code, their exploratory analysis code, their modelling code, and their model deployment code. A branch could be created for each of these code types. 

More info: https://guides.github.com/introduction/flow/

## What is origin? What is remote? 

Although git can be used exclusively on a local machine, most git projects also have a server-hosted repository. In many cases, this is github.com or bitbucket.com. The server-hosted repository is typically referred to as the `remote`  

Similar to how most (all?) git projects are pre-configured with a default branch named `master`, once a git repository is cloned, the default name for the remote git repository is `origin`. This name is used to specify which remote repository to use for various commands.  

So, although most beginners will typically run the following commands:
```bash
git pull
git add .
git commit -m "dope commit"
git push
```
The implicit commands being run are:
```bash
# with master branch checked out
git pull origin master
git add .
git commit -m "dope commit"
git push origin master
```

This is important because in (the more advanced) "forking" workflow, there will be 2 remote repositories - the source repository and the forked repository. A common git convention for this workflow is naming the source remote repository `upstream` and the forked remote repository `origin`. 

Another common source of confusion surrounds when `origin` is used by itself and when it is used like `origin/branch_name`. The difference lies in the specifications of the git commands.  

For example, the specification for `git pull` and `git push` look like:
```bash
git push [-options] [<repository> [<refspec>]]
```
  - `refspec` is the name of the branch in most use cases  
  - `repository` is `origin` or `upstream` in mose configurations  

However, the specification for `git rebase` looks like: 
```bash
git rebase [-options] [<branch>]
```
  - `branch` is `new_branch` for the local version of the branch 
  - `branch` is `origin/new_branch` for the remote version of the branch

## What's the difference between tracked and untracked files? 

Shown when `git status` is run. A file is untracked if it has never been included in a previous commit (exceptions for files that were added and then removed, see below)

## What is `git rm`?

Just like git tracks creating a new file as a change, it also tracks deleting a file as a change. One way to delete a file and track the change is: 
```bash
rm file.txt
git add file.txt
```
However, "adding" a file deletion change is kind of confusing, so `git rm` is provided as a less confusing shortcut for the above commands. 

Note: `git rm` will not work on untracked files since the file has not already been adding to git's tracking and therefore there's nothing for git to remove. To prove this, first create a file, add it, and commit it. Then, remove the file and commit the removal. Then create the same file again and run `git status`. The file should appear in the "untracked files" section. 
```bash
# add file
touch file.txt
git add file.txt
git commit -m "add file.txt"

# remove file
git rm file.txt
git commit -m "remove file.txt"

# add file again
touch file.txt
git status

# file should be shown in "untracked files" 
```

# Quick Tips:

Eliminate changes from tracked files    
```
git checkout /path/to/file
```
Note: it's confusing that checkout is used to switch branches, move to specific commits, and elimiate changes from specific files, but I'm sure it make sense under the hood??

Eliminate changes from untracked files (and deletes file)
```
git clean -f /path/to/file/
```

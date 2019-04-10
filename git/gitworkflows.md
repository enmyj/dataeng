## Good git/flow references
Very thorough intro to git and workflows: https://www.atlassian.com/git/tutorials/  
Schematic demonstrating basic workflow: https://guides.github.com/introduction/flow/  

## Git Flow Example:
#### Download repo
```bash
git clone <repo> # using link from github.com
cd <repo>
```
#### Create new branch and make changes
```bash
git checkout -b <branch_name>
# make file changes
git add file1 file2 file3
git commit -m "message"
# etc.
```
#### Collaborate (& listen)
```bash
git push origin <branch_name>
# File Pull Request (PR) on Github website to merge new_branch into master
# Request review on PR
# Get PR merged!
```
#### Synchronize Changes Locally
```bash
git checkout master
git pull origin master
git branch -d <new_branch> # delete new_branch
```

## Forking Collaboration Workflow
Forking tutorial: https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow

Purpose of forking:
> The main advantage of the Forking Workflow is that contributions can be integrated without the need for everybody to push to a single central repository. Developers push to their own server-side repositories, and only the project maintainer can push to the official repository. This allows the maintainer to accept commits from any developer without giving them write access to the official codebase.

Note: Forking can similarly be used on smaller projects to prevent accidents from impacting the central repository

#### Create fork and download repo
```bash
# Find repository on github website (a.k.a. "central" or "maintainer" repository) 
# Create fork on github website
git clone <repo> # using link from fork
```
#### Set references to remote git repos
```
# set remote for central (source) repository: 
git remote add upstream <repo> # using link from central (source) repository
# check remotes
git remote -v
```
Note: This command should show `origin` associated with the url for your fork and `upstream` associated with the url for the maintainer repository.  
Also note: `origin` and `upstream` are just common conventions but could actually be named anything 
#### Create new branch and make changes
```bash
git checkout -b <branch_name>
# make file changes
git add file1 file2 file3
git commit -m "message"
# etc.
```
#### Collaborate (& listen)
```bash
# push to forked repository
git push origin <branch_name>

# File Pull Request (PR) on Github website to merge the forked version of new_branch into central/source version master
# Request review on PR
# Get PR merged!
```

#### Synchronize Changes Locally
```bash
git checkout master
git pull origin master
git branch -d <new_branch> # delete new_branch
```
## Local Merge Workflow

#### Download repo
```bash
git clone <repo> # using link from github.com
cd <repo>
```
#### Create new branch and make changes
```bash
git checkout -b dev
# make file changes
git add file1 file2 file3
git commit -m "message"
# etc.
```
#### Merge changes locally using rebase strategy and push changes to origin/master
```bash
# update local version of master
git checkout master
git pull origin master

# OPTIONAL: move all commits from dev ahead of all commits from master
git checkout dev
git rebase master

# merge dev into master
git checkout master
git merge dev
git push origin master
```


### Advantages of forking/pull request workflow
- Centralized location (Pull Request) for code discussion
- Encourages code review process because PRs are typically merged by someone other than the author
- Branches are typically pushed to remote repositories so others can view them and work on them as desired. Also, remote repositories provide backup in the event of local computer failure. 
- Relatively (for git) clear process for merging branches
- Low communication required to collaborate on the same branch
- Easy to incorporate continuous integration (e.g., A tool like Jenkins will typically kick off continuous integration tests whenever a Pull Request is filed)

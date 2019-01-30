## An Awesome Git tutorial/reference
https://www.atlassian.com/git/tutorials/

## Basic Collaboration Workflow
Schematic demonstrating basic workflow: https://guides.github.com/introduction/flow/  
Github's tutorial: https://services.github.com/on-demand/github-cli/  
#### Download repo
0. Create repository on github website
1. `git clone <repo>` -- using link from github.com
2. `cd <repo>`
#### Create new branch and make changes (hack da mainframe)
3. `git checkout -b <branch_name>` (or `git branch <branch_name>` then `git checkout <branch_name>`)
4. Crush some code
5. `git commit -m "message"`
6. Crush some code
7. `git commit -m "message"`
#### Collaborate (& listen)
8. `git push origin <branch_name>`
9. File Pull Request (PR) on Github website
10. Request review on PR
11. Have reviewer merge PR
#### Synchronize Changes Locally
12. `git checkout master`
13. `git pull origin master`
14. `git branch -d <new_branch>` -- delete `new_branch`

## Forking Collaboration Workflow
Forking tutorial: https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow

Purpose of forking:
> The main advantage of the Forking Workflow is that contributions can be integrated without the need for everybody to push to a single central repository. Developers push to their own server-side repositories, and only the project maintainer can push to the official repository. This allows the maintainer to accept commits from any developer without giving them write access to the official codebase.

Note: Forking can similarly be used on smaller projects to prevent accidents from impacting the central repository
#### Create fork and download repo
0. Find repository on github website (a.k.a. "central" or "maintainer" repository) 
1. Create fork on github website
2. clone fork `git clone <repo>` -- using link from fork
#### Set references to remote git repos
3. set remote for central repository: `git remote add upstream <repo>` -- using link from central repository
4. view remotes: `git remote -v`  
   Note: This command should show `origin` associated with the url for your fork and `upstream` associated with the url for the maintainer repository.  
   Also note: `origin` and `upstream` are just common conventions but could actually be named anything 
#### Make changes and hack da mainframe
3. `git checkout -b <branch_name>`
4. Crush some code
5. `git commit -m "message"`
6. Crush some code
7. `git commit -m "message"`
#### Collaborate (& listen)
8. push commits to forked remote: `git push origin <branch_name>`
9. File Pull Request (PR) on Github website.  
   Note: this pull request will look a little different than above - the base will be `central/master` and the comparison branch will be `your_username/new_branch`
10. Request review on PR
11. Have reviewer merge PR
#### Synchronize Changes Locally
12. `git checkout master`
13. `git pull upstream master`
14. `git branch -d <new_branch>` -- delete `new_branch`

## Local Merge "Old School" Workflow

#### Download repo
1. `git clone <repo>` -- using link from github.com
2. `cd <repo>`
#### Make changes and hack da mainframe
3. `git checkout -b dev`
4. Crush some code
5. `git commit -m "message"`
6. Crush some code
7. `git commit -m "message"`
8. `git push origin dev`
#### Merge changes locally using rebase strategy and push changes to origin/master
9. `git checkout master`
10. `git pull origin master` -- sync local `master` with `origin/master`
11. `git checkout dev`
12. `git rebase master` -- move local `dev` branch to tip of `master` branch
13. `git checkout master`
14. `git merge dev` -- merge local `dev` into `master` (note: no merge commit created)
15. `git push origin master`

### Advantages of forking/pull request workflow
- Centralized location (Pull Request) for code discussion
- Encourages code review process because PRs are typically merged by someone other than the author
- Relatively (for git) clear process for merging branches
- Low communication required to collaborate on the same branch
- Easy to incorporate continuous integration (e.g., A tool like Jenkins will typically kick off continuous integration tests whenever a Pull Request is filed)

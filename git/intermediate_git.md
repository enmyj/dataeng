
---
You make a commit on a local branch, forget to `git pull`, and attempt to `git push`. You see something like this: 
```
To https://github.com/trimyjer/git_training.git
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'https://trimyjer@github.com/trimyjer/git_training.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
Like the message says, someone else commited to the remote version of your branch before you could commit. How to fix: 
```bash
git pull --rebase origin branch_name
git push origin branch_name
# or
git fetch --all
git rebase origin/branch_name
git push origin branch_name
```
https://stackoverflow.com/questions/24114676/git-error-failed-to-push-some-refs-to


---
You make a commit on a local branch, but someone else has made a commit on the same remote branch. You run `git pull` and it drops you into a text editor that looks like this: 
```
Merge branch 'master' of https://github.com/username/repo

# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
``` 
WTF is this doing?    
1. Treats the remote version of the branch as the source of truth
2. Treats the local version of the branch as a "separate" branch
3. Merges the commits from the local branch into the remote branch using "3-way" merge. The commit order during the merge is determined by the timestamp of the commit(s) on both branches.       

Is this fine? Yes. But it makes the git history look hella stupid. In the long run, it's preferable to use `git pull --rebase` as the pulling strategy instead. There are lots of ways to set "rebase pulls" as the default pulling strategy, but one option I like is to only allow git to pull when the branch can be "fast forwarded" (pulled with no merge commit). This can be done by setting the following:

```bash
git config --local pull.ff only
```

If it's already too late and you've made the merge commit, do the following: 
```
git reset --soft origin/branch_name
git commit -am "message"
git push origin branch_name
```
NOTE: This will not bomb changes made on the branch, but it will bomb all of the commits on the branch...

---
Is there any reason to merge `master` into `branch`? Only if you want dumb merge commits on your `branch`. Instead use `rebase`: 
```bash
git checkout branch

# rebase against the local version of master
git rebase master 

# rebase against the remote version of master
git fetch --all
git rebase origin/master
```
https://stackoverflow.com/questions/16955980/git-merge-master-into-feature-branch


---
Eliminate changes from tracked files    
`git checkout /path/to/file`

Eliminate changes from untracked files (and deletes file)
`git clean -f /path/to/file/`




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

Is this fine? Yes. But it makes the git history look hella stupid. If it's already too late and you've made the merge commit, do the following: 
```
git reset --soft origin/branch_name
git commit -am "message"
git push origin branch_name
```




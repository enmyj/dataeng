# Ian's guide to avoiding common git mistakes and/or confusion

Disclaimer: I'm a linear history (rebase) kinda dude, bro.  

## When can I `git checkout` branches? 

You can `git checkout` any time the current changes in the staging area (tracked) would not conflict with the files on the branch you are trying to check out.  

Usually the easiest way to do this is to have no files in your staging area prior to running `git checkout`. This can be achieved using `git commit` or `git stash`

---

## When can I `git pull` without merge/rebase conflict?

You can `git pull` any time the current changes in the staging area (traced) would not conflict with the files on the remote branch you are trying to pull. More below...  

---

## `git push` before `git pull` 
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
Like the message says, someone else commited to the remote version of your branch before you could commit. Git is throwing an error because now your commit history looks different than the commit history on the remote. Since the remote is the "source of truth" git wants you to fix your history prior to pushing. How to fix:
```bash
# with branch_name checked out

git pull --rebase origin branch_name
git push origin branch_name
# or
git fetch --all
git rebase origin/branch_name
git push origin branch_name
```
https://stackoverflow.com/questions/24114676/git-error-failed-to-push-some-refs-to

---

## `git pull` merge commit
You make a commit on a local branch. Someone else has made a commit on the same remote branch. You run `git pull` and it drops you into a text editor that looks like this: 
```
Merge branch 'master' of https://github.com/username/repo

# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
``` 
You mash `:wq!` in vim but still...WTF?    
1. Git treats the remote version of the branch as the source of truth
2. Git treats the local version of the branch as a "separate" branch (even though they have the same name)
3. Git merges the commits from the local branch into the remote branch using "3-way" merge. The commit order during the merge is determined by the timestamp of the commit(s) on both branches.       

Is this OK?? Yes...  

However, it makes the git history much harder for others to follow. In the long run it's preferable to use `git pull --rebase` as the pulling strategy instead. There are lots of ways to set "rebase pulls" as the default pulling strategy, but one option I like is to only allow git to pull when the branch can be "fast forwarded" (pulled with no merge commit). This can be done by setting the following:

```bash
git config --local pull.ff only
```

If it's already too late and you've made the merge commit, but you are desparate to remove the merge commit, you can do the following: 
```
git reset --soft origin/branch_name
git commit -m "message"
git push origin branch_name
```
NOTE: This will not bomb changes made on the branch, but it will bomb all of the commits on the branch...

---
## Rebase vs. Merge (basics)

My opinion is that if you are using the proper branching strategy and you understand the git commands you are typing, rebasing is preferable. 

Rebasing pros:  
  - Maintains linear commit history with no "merge" commits
  - The concept of rebasing one branch onto the tip of another branch makes conceptual sense
  - The time-based order of commits doesn't really matter in most cases so 3-way merges make less sense than rebases

Rebasing cons:
  - Can be confusing/intimidating, especially with regard to commit timestamps
  - If you've already pushed your work to a remote branch, you'll have to force push it after rebasing. This rewrites the history on the remote version of the branch which many people hate. 

https://stackoverflow.com/questions/16955980/git-merge-master-into-feature-branch

Example: You create a branch off `master` and make a few of commits on it. Then, a pull request with some code you'd like to use is merged into `master`, creating a new commit. Since your code was branched off of an older commit on master, you need a way to incorporate this new commit into your branch.  

Rebase:
```bash
# update local with changes made to remote
git fetch --all
git checkout master
git pull origin master

# move all commits from branch_name to tip of master
# as though you had created the branch from that point
# and then made all the commits
git checkout branch_name
git rebase master

# resolve any conflicts as appropriate
# then force push since you re-wrote the commit history
# by including the new master commit in your branch
git push origin branch_name -f

# coworkers can update their version of branch by running
git reset --hard origin/branch_name
```

Merge:
```bash
# update local with changes made to remote
git fetch --all
git checkout master
git pull origin master

# bring new commits from master into branch
# using 3-way merge strategy
# new commit order will be based on commit time
git checkout branch_name
git merge master

# resolve any conflicts and save merge commit in vim or whatever
# force push??
git push origin branch_name
```

To be continued once I have internet access...
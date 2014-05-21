#!/bin/sh -ex
REPO=tree

init() {
    rm -fr $REPO
    git init $REPO
    cd $REPO
    touch README.txt
    git add README.txt
    git commit -m "initial commit"
    cd ..
}

commit() {
    for i in $@
    do
	date >> README.txt
	git add README.txt
	git commit -m "README更新 ${i}"
    done
}

branch() {
    git checkout  `git log --format='%h' master|tail -1`
    git branch release0.x
    git branch release1.x
}

release() {
    git checkout release0.x
    git merge --no-ff master -m "$1 リリース"
    git tag $1
    git checkout master
}

fix() {
    git checkout release0.x
    date >> README.txt
    git add README.txt
    git commit -m "fix README"
}

init

cd $REPO
commit 1-1 1-2 1-3
# コミット後にブランチを作成する(先頭に作成)
branch
release v0.1
commit 2-1 2-2
release v0.2
fix
git log --graph --decorate --oneline release0.x
git log --graph --decorate --oneline master




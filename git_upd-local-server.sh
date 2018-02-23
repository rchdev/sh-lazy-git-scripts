#!/bin/sh

if [ -z "`git status --porcelain`" ]
    then
      echo -e "\e[0;31m Nothing to commit.\e[0m"
      exit
fi

branch="`git rev-parse --abbrev-ref HEAD`"

if [ -z "$branch" ]
  then
    echo -e "\e[0;31m Aborted.\e[0m"
    exit
fi

prefix=$(echo "$branch" | cut -d'/' -f 2 | cut -c1-6)

if [ "$prefix" != "local-" ]
  then
    echo -e "\e[0;31m You must checkout to an local-server type branch.\e[0m"
    exit
fi

echo -e "\e[0;32m Enter commit message (leave blank to abort).\e[0m"
echo -n -e "\e[1;36m [commit]: \e[0m"
read commit

if [ -z "$commit" ]
  then
    echo -e "\e[0;31m Aborted.\e[0m"
    exit
fi

git add --all
git commit -m "$commit"
git checkout local-master
git merge --no-ff --no-edit $branch
git push local-server-1 local-master
git checkout $branch
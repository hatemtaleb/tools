#!/bin/bash


repo_url='https://your/repo/url.git'
repo_name='aps' 
repo_backup="${repo_name}-back.git" 
repo_clean="${repo_name}-clean.git"
binary_extention list='.ear * zip *-war *.tar *.tar-gz * jar'


echo "repo_name: ${repo_name}"
echo -e "repo_backup : ${repo_backup}"
echo -e "repo_clean : ${repo_clean}"
echo -e "binary_extention_list : ${binary_extention_list}"


echo -e "\e[32mcreate local backup of repository to restore if we have some issue : ${repo_backup}\e[0m" 
git clone --mirror ${repo_url} ${repo_backup} 
echo -e "\e[32mcreate a repository for the operation: ${repo_clean}\e[0m"
cp -rp ${repo_backup} ${repo_clean}
cd ${repo_clean}

#check the repository size 

old_size=$(du -kbsh)

echo "\e[31mthe repository size before the operation is : ${old_size}\e[0m"
echo -e "cleanup old references \e[31m${binary_extention_ list}\e[0m"

git filter-branch -f\
    --prune-empty
    --tag-name-filter cat \
    --tree-filter "git rnm -rf --ignore-unmatch ${binary_extention_list}" \
    -- --all
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
git reflog expire --expire-now --all && git gc --prune-now --aggressive 

new_size=$(du -kbsh)

echo -e "the repository size before the operation is: \e[31m${fold_size}\e[em and after the operation is : \e[32m${new_size}\e[0m"
echo -e "to Push the the modification please use this commandes"
echo -e "cd ${repo_clean}"
echo -e "\e[31mgit push --mirror \e[0m"
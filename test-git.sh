#!/bin/sh

# ./test-git.sh ./user-service
# git checkout develop && git branch -d release

sys_log(){
    message=$1

    echo "[System]" $message
}

update_repo()
{
    sys_log "Updateing repository....."
    git fetch -a
}

is_branch() {
    local branchName=$1
    local is_found=0
    sys_log "Check branch......\"${branchName}\""
    # echo $gitBranches
    if [[ $gitBranches == *$branchName* ]]; then
        echo "Found"
        sys_log "Found......\"${branchName}\""
        is_found=1
    else
        sys_log "Not found....... \"${branchName}\""
        is_found=0
    fi

    return $is_found
}

get_all_branch(){
    sys_log "Checking all branches......"
    gitBranches=$(git branch -a)

    echo
    echo $gitBranches
    echo
}

create_branch(){
    if [ "$is_found_remote_beanch" -eq "0" ] && [ "$is_found_local_beanch" -eq "0" ]; then
        sys_log "creating the new branch from develop branch...'${targetBranch}'"

        git checkout -b $targetBranch $fromBranch
        # local result=$(git checkout -b $targetBranch $fromBranch)
        # local result="${gitResult##*()}"
        # sys_log "GIT response => " $result
        # local result="Switched to a new branch 'xxxx'"

        # TODO:
        # local isSuccess=0
        # if [[ $result == "Switched to a new branch"* ]]; then
        #     sys_log "Create new branch successfully......${targetBranch}"
        #     isSuccess=1
        # else
        #     sys_log "Can't create the new branch......${targetBranch}"
        #     isSuccess=0
        # fi
        # echo "isSuccess => " $isSuccess

        sys_log "[finished] Create the new branch"

        # return $isSuccess
    else
        sys_log "Can't process when found the branch on remote/local repository"
    fi
}

push_branch() {
    sys_log "Pushing the new branch to remote"

    git push origin $targetBranch

    sys_log "[finished] Push the new branch"
}

now=$(date)
echo "Today is $now"

path=$1
sys_log "PATH to execute: " $path

if [ -z "$path"]; then
    echo "\$path is NULL"
else
    sys_log "Going to the new directory....." $path
    cd $path
fi

targetBranch="release"
fromBranch="remotes/origin/develop"

update_repo
get_all_branch
is_branch "${targetBranch}"
is_found_local_beanch=$?
# echo $is_found_local_beanch

# if [ "$is_found_local_beanch" -eq "0" ]; then
# echo "LOCAL xxxxxxx"
# else
# echo "LOCAL yyyyyyyy"
# fi

is_branch "remotes/origin/${targetBranch}"
is_found_remote_beanch=$?
sys_log REMOTE "=>" $is_found_remote_beanch
sys_log Local "=>" $is_found_local_beanch

create_branch
# create_status=$?

git branch

push_branch

sys_log "................Finished................"

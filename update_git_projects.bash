#!/bin/bash

config=/home/$(whoami)/git_projects/scripts/setup/config.txt
source ${config}

# Pull and Update
PAU()
{
    local project=$1
    local branch=$(git rev-parse --abbrev-ref HEAD)
    git checkout develop
    git pull
    git checkout ${branch}
}

projects=(
    coding_challenges
    scripts
    expense_report
    recipes
    docker-sqlite3
)

for project in "${projects[@]}"
do
    PAU "${project}"
done

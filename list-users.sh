#!/bin/bash

helper()

#GitHub API URL
API_URL="https://api.github.com"

#GitHub username and personal access token
USERNAME=$username
TOKEN=$token

#Github user and repo information
REPO_OWNER=$1
REPO_NAME=$2

#Function to make a GET request to the Github API
function github_api_get{
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    #send a get request to the github API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list users with read access to the repository
function list_users_with_read_access{
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators

    #fetch list of collaborators on the repo
    collaborators="${github_api_get "$endpoint" | jq -r '.[] | select{.permissions.pull == true} | .login'}"

    #display list of collaborators
    if [[ -z "$collaborators" ]]: then
        echo "no users with read access found for ${REPO_OWNER}/${REPO_NAME}"
    else
        echo "users with read access to ${REPO_OWNER}/${REPO_NAME}: "
        echo "$collaborators"
    fi
}

#Make sure that the script is run with two arguements
function helper{
  expected_cmd_args=2
  if [ $# -ne $ expected_cmd_args]; then
  echo "please execute the script with required cmd args"
  echo "asd"
}

















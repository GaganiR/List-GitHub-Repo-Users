# List-GitHub-Repo-Users

## Overview 
GitHub API Integration with Shell Scripting. This project automates the process of retrieving and displaying user access information for any GitHub repository. The __Bash script__ interacts with the __GitHub API__ to list the users who have read access to a specified GitHub repo. The process includes creating an __EC2 instance__, authenticating with __GitHub Token__, excecuting the script with command line arguements for repo owner and repo name, handling __JSON__ data with __jq__, and filter the users with "pull" permissions. 

## Setting the GitHub API URL
The URL of the GitHub API is the foundation for constructing API endpoints. Hence we store the URL in the 'API_URL' variable. This URL can be found from GitHub Api documentation.
```
API_URL="https://api.github.com"
```
## GitHub Authentication using personal access token
The script needs to be authenticated in order to interact with the Github API. Since the username and token contain sensitive information, it is recommended to set them as environment variables for security reasons. 
```
USERNAME=$username
TOKEN=$token
```

## Repository Information
This states which repository is targetted to check its users with read access. The variables 'REPO_OWNER' and 'REPO_NAME' should hold the Github username/organization owing the repo and the name of the repository under them which you want to investigate. These two values are entered as command line arguements when you run the script which are read respectively as $1 and $2. Later when running the script, you will see that I enter $1 as GaganiR and $2 as AWS-Resource-Tracker-.
```
REPO_OWNER=$1
REPO_NAME=$2
```

## Functions
This bash script consist of three functions:

## 1. Function 'github_api_get'
This facilitates GET requests to the Github API. It accepts an endpoint as the $1 arguement which holds the repo owner's username. Then we construct the full URL by adding the endpoint to the API_URL. Then 'curl' command is used to send the request including the authentication details. 
```function github_api_get{
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    #send a get request to the github API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}
```

## 2. Function 'list_users_with_read_access'
This function is tasked with listing the users who have read access to the specfied github repo. Usually such an output will be in JSON format which includes a full list of information about collaborators. But since we only need those user's names, we will use __jq__ to parse the JSON format.
If the list of collaborators is empty then print that no user has read access. If the list is not empty then it should print the list of collaborators names.
```
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
```

## 3. Function 'helper'
This is to make sure that the user has put two arguments when the script is run by a user.
If the list of command line arguements is not equal to two, then this will print the following message.
```
function helper{
  expected_cmd_args=2
  if [ $# -ne $ expected_cmd_args]; then
  echo "please execute the script with required cmd args"
  echo "asd"
}
```
![image](https://github.com/user-attachments/assets/248f5de3-d55c-4e06-bb4e-637bf16c881d)

#!/bin/bash

export REPO_DIR=${REPO_DIR:-/home/git/scm}
export REPO_NAME_LENGTH=${REPO_NAME_LENGTH:-6}
export REPO_PASS_LENGTH=${REPO_PASS_LENGTH:-12}
export HTTP_CONFIG_FILE=${HTTP_CONFIG_FILE:-/home/git/conf/lighttpd.conf}

function generate_rand_str () {
    chars='abcdefghijklmnopqrstuvwxyz'
    n=${1}
    str=
    for ((i = 0; i < n; ++i)); do
        str+=${chars:RANDOM%${#chars}:1}
        # alternatively, str=$str${chars:RANDOM%${#chars}:1} also possible
    done
    echo "$str"
}

function add_config_snippet () {

cat << EOF >> ${HTTP_CONFIG_FILE}
\$HTTP["url"] =~ "${1}" {
    auth.backend = "plain" 
    auth.backend.plain.userfile = "/home/git/conf/${1}-user-info" 
    auth.require = ( "" => ("method" => "basic", "realm" => "PasswordProtected", "require" => "valid-user") )
    setenv.set-environment = ( "GIT_PROJECT_ROOT" => "/home/git" )
    setenv.set-environment += ( "GIT_HTTP_EXPORT_ALL" => "" )
}
EOF

}

for param in $(echo "$QUERY_STRING" | tr '&' '\n'); do
    key=$(echo "$param" | cut -d'=' -f1)
    if [[ "${key}" == "protect" ]]; then
        PROTECT=true
    elif [[ "${key}" == "users" ]]; then
        REPO_USERS=$(echo "$param" | cut -d'=' -f2 | tr '+' ' ')
    fi
done

cd ${REPO_DIR}

REPO_NAME=$(generate_rand_str 6)
REPO_USERS=${REPO_USERS:-1}

git init ${REPO_NAME}

if [[ "${PROTECT}" == "true" ]]; then
    add_config_snippet ${REPO_NAME}
    echo "" > /home/git/conf/${REPO_NAME}-user-info
    counter=0
    while [ $counter -lt ${REPO_USERS} ]; do 
        REPO_PASS=$(generate_rand_str 8)
        echo "git_user${counter}:${REPO_PASS}" >> /home/git/conf/${REPO_NAME}-user-info
        ((counter++))
    done
fi


kill -USR1 $(ps -ef | grep lighttpd | grep -v grep | awk '{print $2}')

echo ""
echo "<html><body>"
echo "<div>"
echo "<span> Created Repo: ${REPO_NAME} </span>"
echo "<span> Repo Creds: </span>"
echo "<span> $(cat /home/git/conf/${REPO_NAME}-user-info) </span>"
echo "</div>"
echo "</body></html>"
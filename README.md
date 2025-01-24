# Overview
    This project sets up a local git server with http accessibility and the ability to create new repos via the http interface

# Quickstart

1. Build the Dockerfile in this directory and tag it git-server-image (or something logical)
    ```
    docker build . -t git-server-image
    ```
2. Run the git server container, several options are required - see example below

    ```
    docker rm -f git-server && \
    docker run -it --name=git-server \
    -v <A LOCAL DIR TO STORE YOUR REPO DIRECTORIES>:/home/git/scm \
    -p 8888:80 \
    -e RESPONSE_FORMAT=text \
    -e REPO_URL_BASE=http://<IPADDRESS OF SERVER>:8888 git-server-image
    ```

3. to use the server you'll need to initialize a new repo, you can use the /create endpoint to do that
    ```
    curl http://<IPADDRESS OF SERVER>:8888/create?name=<REPO_NAME>
    ```
    NOTE: there are a bunch of options to the /create endpoint explained below

4. clone the newly created repo

    ```
    git clone http://<IPADDRESS OF SERVER>:8888/scm/<REPO_NAME>
    ```

# /create OPTIONS

- name (str):[*] name of the repo to create - if you dont specify a name, a randomly named repo will be created; NOTE: you cannot overwrite or update an existing repo - if you specify an existing repo name the 
- protect(str):[true|false] if specified, 1 or more users will be created with random passwords - if not specified the repo will be public; no login
- users(int):[1-99] number of random users with passwords to create with a repo - if you dont specify users (but do specify protect) this defaults to 1
- response_format(str): [html|text] the cgi script behind /create returns a very basic response and it can be html or plain text formatted.
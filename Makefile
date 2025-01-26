.PHONY: build_and_run build_and_run_public

# Define the target 'build_and_run'
build_and_run:
	# Build the Docker image
	docker build --rm -t git-server-image .
	
	# Remove the existing container (if any) and run a new one
	docker rm -f git-server || true && \
	docker run -it --name=git-server \
		-v /Users/av/scm:/home/git/scm \
		-p 8888:80 \
		-e RESPONSE_FORMAT=json \
		-e SITE_URL=http://127.0.0.1:8888 \
		git-server-image

build_and_run_public:
	# Build the Docker image
	docker build --rm -t git-server-image .
	
	# zrok share public --headless http://localhost:8888
	
	# Remove the existing container (if any) and run a new one
	docker rm -f git-server || true && \
	docker run -it --name=git-server \
		-v /Users/av/scm:/home/git/scm \
		-p 8888:80 \
		-e RESPONSE_FORMAT=json \
		-e SITE_URL=${SITE_URL} \
		git-server-image
# ;;
# bash_in:
#     docker exec -it git-server /bin/bash
# ;;
# cleanup:
# 	docker kill git-server
#     docker image rm -f git-server-image  
# Week 1 — App Containerization


## Containerize Application (Dockerfiles, Docker Compose)

During the live stream we containerized both the frontend and the backend of our application. We accomplished this by first creating the Dockerfiles for both the frontend and the backend, and then creating and running the docker-compose file. A lot of this was review, but I did learn a lot from our two guest speakers specifically surrounding some of the best practices of working with both Dockerfiles and docker-compose files in a work setting. 


## Post-Stream Tasks

I worked on tasks we weren't able to complete during live stream. These tasks included the following: 
    - Returning the container id into an Env Var
    - Sent curl to test server
    - Checked container logs
    - debugged adjacent containers with other containers
    - gained access to a container via docker exec
    - deleted an image.

I wasn't able to override ports successfully, but I opted to proceed without too much troubleshooting. Exporting the container id to an env var made subsequent commands easier to execute; I could see how this would be beneficial in other use cases such as scripting. 

![]()
![]()
![]()

### Adding DynamoDB Local and Postgres


![]()
![]()

### Documented the Notification Endpoint for the OpenAI Document


![]()

### Write a Flask Backend Endpoint for Notifications and React Page for Notifications

![]()
![]()

## Homework Challenges

### Run the Dockerfile CMD as an external script

![]()

### Push and tag a image to DockerHub

References:
    - <https://www.geeksforgeeks.org/how-to-tag-an-image-and-push-that-image-to-dockerhub/>
    - <https://stackoverflow.com/questions/28349392/how-to-push-a-docker-image-to-a-private-repository>

I struggled with this a little bit because I had a misunderstanding of how to target my private image registry. I followed these two articles to complete this exercise. I ended up re-tagging my image several times prior to finally landing on the following: 
fomomoh08/aws-cloudproject-bootcamp:backend-flask. After completing the docker login command, I was able to push the image successfully to my repository. This will prove useful in future projects.

![DockerHub Image Uploaded]()

### Learn how to install Docker on your local machine and get the same containers running outside of Gitpod/Codespaces

References:
    - <https://docs.docker.com/desktop/install/windows-install/>
    - <https://github.com/docker/compose/issues/9956>

I used docker desktop and Almalinux.

I was able to build both containers and run them concurrently. The docker-compose file failed to run however due to the reference of some env variables unique to gitpod. I didn't wat to mess up my main project branch with experiments, so I created a new branch (docker-localtest). I replaced the environment variable references to reference http://localhost:300 and http://localhost:4567, commented out the OTEL env vars and attempted to run docker-compose up again. This time it failed due to the following error: docker endpoint for "default" not found. After some digging online, I came across a forum where other users ran into the same problem using Docker Desktop for Windows. It's a known bug that has a reliable workaround. After applying the workaround, docker-compose ran successfully and I was able to hit Cruddur at http://localhost:3000 and navigate around the page.

![]()

### Implement a health check in the V3 Docker compose file

References:
    - <https://stackoverflow.com/questions/38895558/docker-healthcheck-in-composer-file>
    - <https://docs.docker.com/compose/compose-file/#healthcheck>

I tried adding a health check to my backend referencing the env vars of my gitpod environment and appending the URL with "/api/activities/home". I used the code below to attempt:

```
    healthcheck:
      test: ["CMD", "curl", "-f", "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}/api/activities/home"]
      interval: 30s
      timeout: 10s
      retries: 3
```

I went on to run the CMD manually to ensure it'll pull the result I was expecting. It returned the value data indicating a successful run however this was not enough to validate that the health check was operational. I first checked the logs of my backend-flask container and did not see any activity beyond my manual tests. I then opened up honeycomb.io to see if there was any evidence available in the traces (honeycomb was instrumented already because I added health checks after week2). 

I found a trace that wasn't created from my manual tests; I concluded that it was my health check that created this trace due to the 404 status code and the timing between successful manual tests. 

![]()

I found 2 other ways to validate the health check's functionality: 1) running a 'docker ps' command and 2) Looking at the status icon of the container for the docker widget in VS Code. This helped me confirm that my backend-flask container was checking in as unhealthy. For this reason I opted to add the health check to the frontend-react-js.

![]()
![]()

Once implemented, the frontend container checked in as healthy. 

![]()

### Research best practices of Dockerfiles and attempt to implement it in your Dockerfile

References:
    - <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>

The best practices article was very extensive. I read this before attempting to create a multi-stage building Dockerfile, so that I could incorporate a few of the techniques. I adopted a few into this task including the following:
     - Using multi-stage builds
    - Minimized layers using only the RUN, COPY and ADD commands that were required
    - Used the recommended Alpine distro
    - Added a label to initialize the organization of my image(s)
    - Combined apt-getupdate and apt-get install in the same line
        - RUN apt-get update && apt-get install -y \




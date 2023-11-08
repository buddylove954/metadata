# Running a Ruby Script in a Docker Container

This guide assumes that you have Docker installed and running on your machine. The Ruby script `fetch.rb` will be executed inside a Docker container.

## Prerequisites

- Docker
- A Docker container with Ruby installed

## Steps to Run the Ruby Script

1. **Find the Container ID**

   First, you need to know the ID of the Docker container you want to execute the script in. You can list all running containers with the following command:

   ```sh
   docker ps
2. ** Exec into the Container with ID**

   docker exec <container_id> ruby /fetch.rb 'www.google.com'

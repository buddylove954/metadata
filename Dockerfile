# Use the official Ruby image as a parent image
FROM ruby:3.1

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app/
COPY . .

CMD ruby fetch.rb

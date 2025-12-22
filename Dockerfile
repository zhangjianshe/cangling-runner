# Use the official Alpine image as the base
FROM alpine:latest

# Install curl, git, and iputils (for ping)
RUN apk add --no-cache curl git iputils

# Set the command to run in the container (you can change this as needed)
CMD ["/bin/sh"]
# Image base
FROM alpine

# Install tools
RUN apk update && apk add --no-cache busybox-extras

# To delete apk to avoid additional installations
RUN apk del apk-tools

# To delete the folder "/etc/apk" to block the access at the repositories
RUN rm -rf /etc/apk

# Create a non-privileged user
RUN adduser -D troubleshooting

# Set the non-privileged user as the default user
USER troubleshooting

#ENTRYPOINT ["telnet"] 
ENTRYPOINT ["ping"] 

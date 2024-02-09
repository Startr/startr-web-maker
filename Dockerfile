# start by pulling the python image
FROM python:3.9-alpine

# Set environment variables for the desired Node.js and npm versions
ENV NODE_VERSION=18.12.1
#ENV NPM_VERSION=9.6.0

# Add community repository to apk
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install required dependencies
RUN apk update && apk upgrade && \
    apk add bash curl make gcc g++ python3

# Install Node.js and npm
RUN apk add --no-cache mc dropbear git nodejs npm 
RUN npm install -g yarn gulp-cli
RUN mkdir -p /srv/web-maker
COPY . /srv/web-maker
RUN cd /srv/web-maker && \
  npm install && \
  gulp release

# copy every content from the local file to the image
COPY . /app

EXPOSE 80

# Run our CMD within the virtual environment
CMD ["pipenv run python app.py"]

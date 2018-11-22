#!/bin/bash

echo 'Did you run:'
echo 'npm login?'
read -p 'y/n: ' didLogin
if [ $didLogin == 'y' || $didLogin == 'Y' || $didLogin == 'yes' || $didLogin == 'Yes' ]
  then
    echo npm login
    else
      echo Nope
      npm login
fi

echo 'npm init --scope=<org_scope>?'
read -p 'y/n: ' inited

if [ $inited == 'y' || $inited == 'Y' || $inited == 'yes' || $inited == 'Yes' ]
  then
    echo Coool
  else
    echo Nope
    echo 'What Org name?'
    read orgName
    npm init --scope=${orgName}
fi
# exit


#############################################
# MIT Licence
cat > LICENSE <<EOL
MIT License

Copyright (c) 2018 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL



#############################################
# Editor Config
cat > .editorconfig <<EOL
# http://editorconfig.org

root = true

[*]
charset = utf-8
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
insert_final_newline = false
EOL

#############################################
# Git ignore
cat > .gitignore <<EOL
/node_modules
.nyc_output
coverage
.DS_STORE
yarn-error.log
yarn.lock
EOL

#############################################
# NVMRC
cat > .nvmrc <<EOL
v8.11.1
EOL

#############################################
# Dockerfile
cat > dockerfile <<EOL
# Cheat Sheet - https://github.com/wsargent/docker-cheat-sheet

FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qqy \
  && apt-get -qqy install \
       dumb-init curl git-all gnupg wget zip ca-certificates \
       python-pip apt-transport-https ttf-wqy-zenhei xvfb \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-unstable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN groupadd -g 10101 bamboo \
  && useradd bamboo --shell /bin/bash --create-home -u 10101 -g 10101 \
  && usermod -a -G sudo bamboo \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'bamboo:nopassword' | chpasswd

RUN mkdir /data && chown -R bamboo:bamboo /data

RUN pip install awscli --upgrade

USER bamboo

ENTRYPOINT ["/usr/bin/dumb-init", "--", \
            "/usr/bin/google-chrome-unstable", \
            "--disable-gpu", \
            "--headless", \
            "--disable-dev-shm-usage", \
            "--remote-debugging-address=0.0.0.0", \
            "--remote-debugging-port=9222", \
            "--user-data-dir=/data"]
EOL

#############################################
# Circle CI
mkdir .circleci
touch .circleci/config.yml
cat > .circleci/config.yml <<EOL
# Javascript Node CircleCI 2.0 configuration file
#
# Check https://circleci.com/docs/2.0/language-javascript/ for more details
#
version: 2

defaults: &defaults
  working_directory: ~/repo
  docker:
    - image: circleci/node:8.11.1

jobs:
  test:
    <<: *defaults
    steps:
      - checkout

      - restore_cache:
          keys:
          - v1-dependencies-
    # fallback to using the latest cache if no exact match is found
          - v1-dependencies-

      - run: npm install
      - run:
          name: Run tests
          command: npm test

      - save_cache:
          paths:
            - node_modules
          key: v1-dependencies-

      - persist_to_workspace:
          root: ~/repo
          paths: .
  deploy:
    <<: *defaults
    steps:
      - attach_workspace:
          at: ~/repo
      - run:
          name: Authenticate with registry
          command: echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/repo/.npmrc
      - run:
          name: Publish package
          command: npm publish

workflows:
  version: 2
  test-deploy:
    jobs:
      - test:
          filters:
            tags:
              only: /^v.*/
      - deploy:
          requires:
            - test
          filters:
            tags:
              only: /^v.*/
            branches:
              ignore: /.*/

EOL




npm install --save-dev chai mocha nyc

echo 'Cool, run npm publish --access public to publish this!'
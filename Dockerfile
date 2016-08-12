FROM ruby:2.3 
MAINTAINER dark.turtle@protonmail.com

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs \ 
  npm

# Compatibility fix for node on debian-based like Ubuntu.
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install nvm.
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | sh

# Invoke nvm to install node.
RUN cp -f ~/.nvm/nvm.sh ~/.nvm/nvm-tmp.sh; \ 
  echo "nvm install node; nvm alias default node; nvm use default; node -v" >> ~/.nvm/nvm-tmp.sh; \ 
  sh ~/.nvm/nvm-tmp.sh; \ 
  rm ~/.nvm/nvm-tmp.sh;

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /code/vmware_ma
WORKDIR /code/vmware_ma

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5
# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
FROM ruby:2.4.2

# Install essentials
RUN apt-get update -qq && apt-get install -y build-essential

# Install dependencies & Chrome
ENV CHROMIUM_DRIVER_VERSION 2.38
RUN apt-get update && apt-get -y --no-install-recommends install zlib1g-dev liblzma-dev wget xvfb unzip libgconf2-4 libnss3 nodejs \
 && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  \
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
 && apt-get update && apt-get -y --no-install-recommends install google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# Install Chrome driver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/$CHROMIUM_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ \
    && rm /tmp/chromedriver.zip \
    && chmod ugo+rx /usr/bin/chromedriver

# Bundle install
ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile.lock contented.gemspec ./
COPY lib/contented/version.rb ./lib/contented/
RUN bundle config --global github.https true
RUN gem install bundler
RUN bundle install --jobs=4 --retry=3

COPY . ./

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD bundle exec rake features DOMAIN=https://library.nyu.edu

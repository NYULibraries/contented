FROM ruby:2.5.1

ENV INSTALL_PATH /app
WORKDIR $INSTALL_PATH
RUN cd $INSTALL_PATH
COPY . ./

RUN wget http://www.freetds.org/files/stable/freetds-1.00.92.tar.gz \
  && tar -xzf freetds-1.00.92.tar.gz \
  && cd freetds-1.00.92 \
  && ./configure \
  && make install
RUN bundle install

FROM ruby:2.3.3

RUN gem install sinatra mysql sinatra-contrib curl

RUN mkdir /usr/src/app 
ADD . /usr/src/app/ 
WORKDIR /usr/src/app/ 
CMD ["ruby","index.rb"]

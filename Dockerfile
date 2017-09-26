FROM ruby:2.4


RUN gem install sinatra

RUN mkdir /usr/src/app 
ADD . /usr/src/app/ 
WORKDIR /usr/src/app/ 
CMD ["/usr/src/app/teste.rb"]

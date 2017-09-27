FROM ruby:2.3.3


RUN gem install sinatra
RUN gem install mysql
RUN gem install sinatra-contrib
RUN gem install curl

RUN mkdir /usr/src/app 
ADD . /usr/src/app/ 
WORKDIR /usr/src/app/ 
CMD ["/usr/src/app/teste.rb"]

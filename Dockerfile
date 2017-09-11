FROM perl:5.22
RUN cpanm Modern::Perl
RUN cpanm JSON::XS
COPY . /myapp
WORKDIR /myapp
EXPOSE 8080
CMD [ "perl", "./server.pl", "-ip", "127.0.0.1", "-port", "8080" ]

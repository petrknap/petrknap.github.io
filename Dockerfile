FROM jekyll/jekyll:4

RUN gem install \
      jekyll-gist \
      webrick \
;

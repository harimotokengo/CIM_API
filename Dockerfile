FROM ruby:3.1

RUN apt-get update -qq && \
    apt-get install -y build-essential \
    nodejs \
    vim \
    default-mysql-client \
    cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# dockerの時間を日本時間に
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# # yarnパッケージ管理ツールインストール
# RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
#     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#     apt-get update && apt-get install -y yarn
# COPY package.json yarn.lock ./

# # Node.jsをインストール
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install -y nodejs

RUN mkdir /cim 
ENV APP_ROOT /cim
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

# bundlerがエラーの原因になったら2.1.4でとりあえず指定
RUN gem update --system && gem install bundler 
RUN bundle install

COPY . $APP_ROOT

# wheneverでcrontab書き込み
# RUN bundle exec whenever --update-crontab 

# # puma.sockを配置するディレクトリを作成
# RUN mkdir -p tmp/sockets
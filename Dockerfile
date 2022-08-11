FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt install -y wget gnupg gnupg1 gnupg2 unzip git make build-essential
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb
RUN apt update && apt install -y esl-erlang
RUN mkdir elixir && \
  cd elixir && \
  wget https://github.com/elixir-lang/elixir/releases/download/v1.14.0-rc.0/elixir-otp-25.zip && \
  unzip elixir-otp-25.zip  && \
  rm -rf man && \
  cp -a * /usr/local
RUN git clone https://github.com/livebook-dev/livebook.git
ENV MIX_ENV=prod
RUN cd livebook && \
  sed -i 's/127, 0, 0, 1/0, 0, 0, 0/g' config/prod.exs &&\
  mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get --only prod && \
  mix compile
WORKDIR /livebook
CMD mix phx.server
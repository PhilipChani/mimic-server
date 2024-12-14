FROM elixir:1.14

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install OTP 24
# RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
#     dpkg -i erlang-solutions_2.0_all.deb && \
#     apt-get update && \
#     apt-get install -y esl-erlang=1:24.0-1 && \
#     rm -rf /var/lib/apt/lists/* # Clean up

# Set environment to production
ENV MIX_ENV=prod

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app


# Compile the project
# Install Node.js and npm
# RUN apt install npm -y

# Install Node.js and npm
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*


# # Install dependencies in assets directory
WORKDIR /app/assets
RUN npm install

# Return to app directory
WORKDIR /app

RUN mix deps.get
#RUN mix do compile
RUN mix phx.digest
RUN mix assets.deploy


ENV SECRET_KEY_BASE="$(mix phx.gen.secret)"
ENV DATABASE_URL=ecto://postgres:8c07edad4b213d80@srv-captain--mimic-database/mimic
ENV PHX_SERVER=true
ENV MIX_ENV=prod

RUN mix release --overwrite
# Expose port 4000 for the app
EXPOSE 4000

# Run the application
CMD ["_build/prod/rel/mimic_server/bin/mimic_server", "start"]
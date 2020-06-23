FROM gitpod/workspace-postgres

# Install Ruby
ENV RUBY_VERSION=2.7.1
RUN rm /home/gitpod/.rvmrc && touch /home/gitpod/.rvmrc && echo "rvm_gems_path=/home/gitpod/.rvm" > /home/gitpod/.rvmrc
RUN bash -lc "rvm install ruby-$RUBY_VERSION && rvm use ruby-$RUBY_VERSION --default"

RUN bash -lc "mkdir -p /home/gitpod/.sdkman/candidates/java/current/jre/lib/amd64/server"
RUN bash -lc "sudo ln -s /home/gitpod/.sdkman/candidates/java/current/lib/server/libjvm.so /home/gitpod/.sdkman/candidates/java/current/jre/lib/amd64/server/libjvm.so"

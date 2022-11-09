# Copyright [2022] [Daniel Gwilt]
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM cm2network/steamcmd

LABEL author="daniel.gwilt.software@gmail.com"

ENV GAME_NAME="zomboid"

USER root
RUN apt-get update
RUN apt-get --yes --force-yes install vim openssh-server sudo
RUN mkdir /var/run/sshd

COPY ./${GAME_NAME}.service /usr/lib/systemd/system/

RUN adduser game-admin
RUN mkdir /opt/game-server
RUN chown game-admin:game-admin /opt/game-server
USER game-admin

COPY ./update_$GAME_NAME.txt /home/game-admin/
COPY ./authorized_keys /home/game-admin/.ssh/
COPY ./servertest.ini /home/game-admin/Zomboid/Server/
COPY ./servertest_SandboxVars.lua /home/game-admin/Zomboid/Server/
COPY ./servertest_spawnregions.lua /home/game-admin/Zomboid/Server/
RUN bash /home/steam/steamcmd/steamcmd.sh +runscript $HOME/update_$GAME_NAME.txt

WORKDIR /opt/game-server

EXPOSE 22
EXPOSE 16261/udp
EXPOSE 16262/udp

VOLUME [ "/home/game-admin/Zomboid" ]

# Reset user to root
USER root

CMD ["/usr/sbin/sshd", "-D"]
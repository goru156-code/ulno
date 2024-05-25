# Ultroid - UserBot
# Copyright (C) 2021-2023 TeamUltroid
# This file is a part of < https://github.com/TeamUltroid/Ultroid/ >
# Please read the GNU Affero General Public License in <https://www.github.com/TeamUltroid/Ultroid/blob/main/LICENSE/>.

FROM theteamultroid/ultroid:main

# set timezone
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY installer.sh .

RUN bash installer.sh

# Install a lightweight HTTP server
RUN apt-get update && apt-get install -y curl

# Create a simple HTTP server script
RUN echo "while true; do echo -e 'HTTP/1.1 200 OK\r\n' | nc -l -p 8080; done" > /root/health_check.sh
RUN chmod +x /root/health_check.sh

# changing workdir
WORKDIR "/root/TeamUltroid"

# expose port
EXPOSE 8080

# start the bot and HTTP server
CMD ["bash", "-c", "bash startup & bash /root/health_check.sh"]

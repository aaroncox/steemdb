FROM python:3.6.2-slim

RUN apt-get update && \
    apt-get install -y git make gcc libssl-dev libgmp-dev python-dev libxml2-dev libxslt1-dev zlib1g-dev

RUN pip3 install steem pymongo autobahn

RUN pip3 install twisted

COPY . /src

CMD ["python", "/src/live.py"]

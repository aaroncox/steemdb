FROM python:3.3.6-slim

RUN apt-get update && \
    apt-get install -y git make gcc libssl-dev libgmp-dev python-dev libxml2-dev libxslt1-dev zlib1g-dev

RUN pip3 install steem steem-piston pymongo scrypt

COPY . /src

CMD ["python", "/src/sync.py"]
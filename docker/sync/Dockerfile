FROM python:3.6.2-slim

RUN apt-get update && apt-get install -y make gcc libssl-dev

RUN pip3 install steem pymongo

CMD ["python", "/src/sync.py"]

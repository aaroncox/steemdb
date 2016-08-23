## steemdb

https://steemdb.com

open source blockchain explorer for the steem blockchain - build on phalcon + mongodb

### Prerequisites

- docker
- bower

### Components

1. `./app/` steemdb website: phalcon + mongodb application for serving out the website, apis, and MVC structure.
2. `./docker/sync` sync service (python + piston) for keeping the blockchain synchronized and up to date. Runs on a 3 second delay and triggers updates in the database.
3. `./docker/history` account history service (python + piston) which runs every 6 hours and analyzes every account on the blockchain. Records historical information as well as a current snapshot.
4. `./docker/witnesses` witness/mining service (python + piston) which runs every minute to pull current witness information as well as the mining queue.
5. `./docker/development` development VM with php7, nginx, and phalcon.

### Getting it running

This explorer syncronizes the entire blockchain into a mongodb database. This takes a LOT of time. **I'd highly recommend you run a local instance of steemd** and modify the `docker-compose.yml` to point to it. It's going to be a lot faster of a sync than trying to read the entire blockchain from a public node.

`docker-compose up` should be all you need to get the development application running.

If you'd like to run any of the syncronization services for initialization, you will need to uncomment the specific service from the `docker-compose.yml` file. For example:

- If you're looking to work on the account pages and start recording their history, uncomment the `history` service and start your containers.

You can uncomment all 3 services to start all applications when docker creates it's containers.

The initial syncronization run by the sync service will take many hours to complete and process all of the blocks. It will also require an enormous amount of disk space. As time progresses, this data will be trimmed. For now in early alpha it's better to have it all.

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

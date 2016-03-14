# peekops
To take a peek on your Ops skills.

# Objective
To pass all test under test/ directory.
```
npm run init # make sure to configure environment file properly.
npm test
```

# Architecture
* Web Server
  - Nginx
  - sshd
* Application Server
  - Express based app
  - sshd
* Database Server
  - Postgres
* Cache Server
  - Redis

You will need to map target machines following this convention:
```
      +-------------+    +-------------+    +-------------+    +-------------+
      |             |    |             |    |             |    |             |
      |     Web     +----+ Application +----+   Database  +----+    Cache    |
      |             |    |             |    |             |    |             |
      +-------------+    +-------------+    +-------------+    +-------------+
```

The test will pick `.env` environment variable and use that to access the servers. Make sure to configure IP address properly.
```
     # Make sure to put correct IP addresses as it may change after reboot.
     WEB_TARGET_MACHINE=192.168.99.101
     APPLICATION_TARGET_MACHINE=192.168.99.102
     CACHE_TARGET_MACHINE=192.168.99.103
     DATABASE_TARGET_MACHINE=192.168.99.104
```

# Rule
- Put your solutions under `solutions` directory.
- Use any tool you need and that you are comfortable with.
- You can use `Vagrant` or `Docker` to manage virtual machines.
- By default all port must be blocked except the one used by application.

# Solutions

- To run solutions, we should run `bash solutions/run_solutions.sh`.
- Configure IP address properly in `.env` file.
- Run `npm test`

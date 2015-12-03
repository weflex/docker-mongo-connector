docker-mongo-connector
=======================================

Docker image for the [mongodb-labs/mongo-connector](https://github.com/mongodb-labs/mongo-connector).

## Tags

- [`weflex/mongo-connector:latest`](./Dockerfile)

## What is docker-mongo-connector?

Docker image with mongo-connector installed. The image is built based on [Python 3.4.3](https://hub.docker.com/_/python/).

## Usage

There are 2 ways to use this docker

#### In Dockerfile

```dockerfile
FROM weflex/mongo-connector:latest
```

By default, the running container will connect:

- mongo specified by `$MONGO`, `$MONGO_USERNAME` and `$MONGO_PASSWORD`
- elasticsearch specified by the host `elasticsearch`

Or directly run:

```sh
$ docker run -d --env=MONGO=localhost --link=elasticsearch:elasticsearch weflex/mongo-connector
```

### In `docker-compose.yml`

```yaml
elasticsearch:
  image: elasticsearch:latest
  command: elasticsearch -Des.network.host=0.0.0.0
mongo_connector:
  image: weflex/mongo-connector:latest
  links:
    - elasticsearch:elasticsearch
  environment:
    - MONGO=endpoint
    - MONGO_USERNAME=user
    - MONGO_PASSWORD=pass
```

## What has been changed

- config the timezone to `Asia/Shanghai`.
- install `mongo-connector:2.1`

## Thanks

This repository is inspired by [yeasy/docker-mongo-connector](https://github.com/yeasy/docker-mongo-connector), Thanks to
[@yeasy](https://github.com/yeasy) to create the upstream one.

## License

MIT

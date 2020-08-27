# docker-sdk-nrf

Toolkit for building application with nRF Connect SDK in Docker.


## Building the image

### with `master` version of `sdk-nrf`

```
docker build -t sdk-nrf .
```

### with specify version of `sdk-nrf`

```
docker build -t sdk-nrf:v1.3.0 --build-arg NCS_VERSION=v1.3.0 .
```

## Run

### ex) build `nrf/samples/nrf9160/https_client` for `nRF9160DK`

```
docker run -it sdk-nrf:v1.3.0 west build -b nrf9160dk_nrf9160ns nrf/samples/nrf9160/https_client
```

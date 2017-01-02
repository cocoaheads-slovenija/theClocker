# Server deployment

## Files to deploy

Create a release build of the app (`swift build -c release`), and copy over the following files:

```shell
cp -rv Config Public Resources .build/release/App .build/release/libCLibreSSL.so /opt/theClocker
```

- [ ] There will be a script to create deploy archives at some time.

## Startup scripts

### systemd based servers (newer Debian / Ubuntu)

Change the values in `clocker.env` as needed.

Copy the file `clocker.service` to `/etc/systemd/system/clocker.service`, and `clocker.env` to `/etc/default/clocker.env`.

Copy the files for **theClocker** app to `/opt/theClocker`.

Use `systemctl` to run the `clocker.service`.

## Proxy setup

In case the server is run behind a proxy (it should), the proxy should be set up to add an `X-base-URL` header to the request, which should hold the base URL string for the service. The base URL string should be complete, including the scheme to use: e.g. `https://host.domain.com`.

### nginx

```nginx
location ~ {
  proxy_set_header X-base-URL $scheme://$host;
  proxy_pass http://127.0.0.1:8080;
}
```


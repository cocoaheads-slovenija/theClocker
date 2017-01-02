# Server deployment

## Files to deploy

Create a release build of the app (`vapor build -c release`), and copy over the following files:

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


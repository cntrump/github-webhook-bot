# GitHub webhook bot

GitHub webhook bot, A simple webhook bot in Swift.

Supported OS: macOS 12+, Linux

Required Swift 5.5+

## How to build

```
$ ./Build.sh
```

Run the server

```
$ ./Run.sh
```

## Run as a daemon

Build and install to system path:

```
$ ./Build.sh
cp .build/release/Run /usr/local/bin/github-webhook-bot
```

Create a systemd configuration file: `/etc/systemd/system/github-webhook-bot.service`:

```ini
[Unit]
Description=GitHub webhook bot, A simple webhook bot in Swift.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/github-webhook-bot serve --env production --hostname 0.0.0.0 --port 8080

[Install]
WantedBy=multi-user.target
```

Enable the service:

```
$ systemctl enable github-webhook-bot
```

Launch the service:

```
$ systemctl start github-webhook-bot
```

Check the service status:

```
$ systemctl status github-webhook-bot
```

Check the log of service:

```
$ journalctl -f -u github-webhook-bot
```


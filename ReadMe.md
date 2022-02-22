# GitHub webhook bot

GitHub webhook bot, A simple webhook bot in Swift.

Supported OS: macOS 12+, Linux

Required Swift 5.5+

## Setup Swift environment on Debian

Debian OS version: `11.2`

Install dependencies:

```
$ apt-get install libpython3-dev \
                  binutils \
                  libgcc-10-dev \
                  libstdc++-10-dev \
                  zlib1g-dev \
                  libcurl4-openssl-dev
```

Download Swift:

for x86_64: [Swift.org](https://www.swift.org/download/)

```
$ curl -OL https://download.swift.org/swift-5.5.3-release/ubuntu2004/swift-5.5.3-RELEASE/swift-5.5.3-RELEASE-ubuntu20.04.tar.gz
$ tar xvf swift-5.5.3-RELEASE-ubuntu20.04.tar.gz
$ mv swift-5.5.3-RELEASE-ubuntu20.04 /opt/swift
```

for Arm64: [Swift-Arm64](https://github.com/futurejones/swift-arm64/releases)

```
$ curl -OL https://github.com/futurejones/swift-arm64/releases/download/v5.5.3-RELEASE/swiftlang-5.5.3-debian-11-release-aarch64-01-2022-02-10.tar.gz
$ tar xvf swiftlang-5.5.3-debian-11-release-aarch64-01-2022-02-10.tar.gz
$ mkdir /opt/swift
$ mv usr /opt/swift/
```

Add to PATH of system:

```
echo 'SWIFT_HOME=/opt/swift' > /etc/profile.d/swift.sh
echo 'PATH=$SWIFT_HOME/bin:$PATH' >> /etc/profile.d/swift.sh
```

Test Swift:

```
$ swift --version

Swift version 5.5.3 (swift-5.5.3-RELEASE)
Target: aarch64-unknown-linux-gnu
```

Test lldb:

```
$ lldb --version

lldb version 10.0.0 (https://github.com/apple/llvm-project.git revision e560cdd64bd089f8c27d7f8e353f78bb6e53017f)
Swift version 5.5.3 (swift-5.5.3-RELEASE)
```

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

## How to use

Supported webhook: GitHub

Supported bot: WeWork

Route for GitHub-Wework bot: `/github/wework`

Add webhook for a repo: 
- Payload URL: `https://{your_server}/github/wework?id={wework_bot_id}`
- Content type: `application/json`
- Secret: empty or generated by `uuidgen`

## Securing your webhook server

Generate an secret token with `uuidgen`:

```
$ uuidgen

C8ADAE99-5584-4DE4-A862-E8261579037E
```

Add an environment variable named `SECRET_TOKEN` for github-webhook-bot:

```
$ export SECRET_TOKEN=C8ADAE99-5584-4DE4-A862-E8261579037E
```

Or define it in `github-webhook-bot.service`:

```ini
[Service]
Environment="SECRET_TOKEN=C8ADAE99-5584-4DE4-A862-E8261579037E"
```

Reload the unit file and restart service:

```
$ systemctl daemon-reload
$ systemctl restart github-webhook-bot
```

## Run as a standalone HTTPS server

Setup SSL certificate:

```
export CERT_FULLCHAIN=/etc/letsencrypt/live/{your_server}/fullchain.pem
export CERT_PRIVKEY=/etc/letsencrypt/live/{your_server}/privkey.pem
```

Or edit `github-webhook-bot.service`:

```ini
[Service]
Environment="CERT_FULLCHAIN=/etc/letsencrypt/live/{your_server}/fullchain.pem"
Environment="CERT_PRIVKEY=/etc/letsencrypt/live/{your_server}/privkey.pem"
```

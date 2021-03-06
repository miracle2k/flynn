# Flynn Demo Environment

This repo contains a Vagrantfile that boots up Flynn layer 0 and then bootstraps
Flynn layer 1.

You need to have [VirtualBox](https://www.virtualbox.org/),
[Vagrant](http://www.vagrantup.com/), and [XZ Utils](http://tukaani.org/xz/)
installed.

### Setup

Check out this repo, and boot up the VM using Vagrant:

```text
git clone https://github.com/flynn/flynn
cd flynn/demo
vagrant up
```

If you see an error unpackaging the box, first make sure you are running Vagrant
v1.6 or later. You may need to install `xz` (`brew install xz` or `apt-get
install xz-utils`).

The final log line contains configuration details used to access Flynn via the
command line tool. Download and install the [CLI](/cli) by running this command:

```bash
L=/usr/local/bin/flynn && curl -sL -A "`uname -sp`" https://cli.flynn.io/flynn.gz | zcat >$L && chmod +x $L
```

After installing the `flynn` command, paste the `flynn cluster add` command from
the Vagrant provisioning log into your terminal.

If you run into a `no such host` error when running the command, verify that
`demo.localflynn.com` resolves to `192.168.84.42` locally. If the domain does
not resolve, your DNS server probably has
[rebinding](https://en.wikipedia.org/wiki/DNS_rebinding) protection on. A quick
workaround is to add this line to your `/etc/hosts` file:

```text
192.168.84.42 demo.localflynn.com example.demo.localflynn.com
```

[See here](https://github.com/flynn/flynn/issues/74#issuecomment-51848061) for
more info.


### Usage

With the Flynn running and the `flynn` tool installed, the first thing you'll
want to do is add your SSH key so that you can deploy applications:

```text
flynn key add
```

After adding your ssh key, you can deploy a new application:

```text
git clone https://github.com/flynn/nodejs-flynn-example
cd nodejs-flynn-example
flynn create example
git push flynn master
```

#### Scale

To access the application, add some web processes using the `scale`
command:

```text
flynn scale web=3
```

Visit the application [in your browser](http://example.demo.localflynn.com) or with curl:

```text
curl http://example.demo.localflynn.com
```

Repeated requests should show that the requests are load balanced across the
running processes.

#### Logs

`flynn ps` will show the running processes:

```text
$ flynn ps
ID                                             TYPE
e4cffae4ce2b-8cb1212f582f498eaed467fede768d6f  web
e4cffae4ce2b-da9c86b1e9e743f2acd5793b151dcf99  web
e4cffae4ce2b-1b17dd7be8e44ca1a76259a7bca244e1  web
```

To get the log from a process, use `flynn log`:

```text
$ flynn log e4cffae4ce2b-8cb1212f582f498eaed467fede768d6f
Listening on 55007
```

#### Run

An interactive one-off process may be spawned in a container:

```text
flynn run bash
```

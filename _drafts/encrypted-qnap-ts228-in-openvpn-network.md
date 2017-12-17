---
layout: blog.post
title: Encrypted QNAP TS-228 in OpenVPN network #solved
category: hardware
keywords:
    - QNAP TS-228
    - OpenVPN
    - encryption
    - VPN
    - QTS
---

We bought QNAP TS-228 as simple storage for @netpromotion some time ago (we also bought Synology DS216se as backup, but it's even worse choice than TS-228).
The role of the NAS is storage for employees, so the **TS-228 looks as great solution for it** (in theory).
Now we know that **we should have bought a HP ProLiant MicroServer** instead.
So if **you are planning to make storage for your company, please use standard server** instead of NAS.

Key features for us was:

 * secure access as being a VPN server & VPN client
 * volume encryption
 * cross-platform file sharing
 * outgoing rsync backup
 * average of 112 MB/s reading and 81 MB/s writing speed


## Applications versus encryption

The main problem of the QNAP TS-228 is implementation of encryption and custom services (like VPN).
It supports only **one volume per drive/RAID pool** and stores **all custom services on data volume**.
The result is that you can have encrypted drive or you can use custom services, but no both at the same time.

**If you enable encryption, all custom services** will be stored on the encrypted volume and **will be stopped** until the drive will be unlocked.
The FAQ knows this problem and has solution:
"Save the encryption key in the NAS."
This is fine, but it has the same effect as if you don't use encryption (which also solves the problem).
So we need another solution.


## Encrypted NAS as VPN server

You must:

 1. unlock the drive to start VPN
 2. access QTS over VPN to unlock the drive
 3. start VPN to access QTS
 4. know that it's impossible

There is **no effective way** how to use encrypted QNAP TS-228 as VPN server.


## Encrypted NAS as VPN client

This way has same problems as previous, but **you have another machine as VPN server**.
The most important for our solution is that **SSH and Cron are system services accessible after boot**.
So you can solve the infinite loop via tunnel to VPN server.


## Our final solution

We use Cron to start SSH tunnel over which we can unlock the volume.
The NAS than starts VPN service and connects to VPN network as client.

```
[~] # crontab -l
* * * * * ps -al | grep -v grep | grep "ssh -N -R 10.110.112.1:4433:127.0.0.1:443 {user}@{server} -p {port}" || ssh -N -R 10.110.112.1:4433:127.0.0.1:443 {user}@{server} -p {port}
```

Where:
 * `10.110.112.1` is IP of VPN server in VPN network (**don't use public IP**, you don't want to have accessible QTS over the Internet)
 * `4433` is our custom port for it higher than 1024 (it's standard 443 + repeated last number)
 * `{user}` is "nobody like" user on VPN server which has no rights - just nobody with login via SSH key
 * `{server}` is domain name (or public IP) of VPN server
 * `{port}` is the SSH port of VPN server

As you can see, it try to find the SSH tunnel in active processes every minute.
If the tunnel was not found, the Cron will start it.
This solves system boot and tunnel crash in one nice command.

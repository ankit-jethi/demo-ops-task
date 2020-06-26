# Demo Ops Task

## How to setup:

There are 2 vagrant boxes - one with docker and the other one with kubernetes.

### Docker:
- From the docker directory, run the [docker-vagrant-box.sh](../master/docker/docker-vagrant-box.sh).

### Kubernetes: (microk8s)
> I don't have any experience with k8s, but I gave it a shot.
- From the k8s directory, run the [k8s-vagrant-box.sh](../master/k8s/k8s-vagrant-box.sh).

#### More info:

- Built the docker image based on **golang:1.13.12-alpine3.12** and pushed it to docker hub.
Check the [Dockerfile](../master/docker/Dockerfile).

- Restart policy:
Set the restart policy to always.

- Sysctl configuration:
Mostly configured referring the `/etc/sysctl.conf` file. A lot of helpful comments in there.
Other changes referring the sources mentioned below.

- [Docker daemon:](../master/docker/daemon.json)
Apart from keep logs size in check, enabled **live restore** to keep containers alive during daemon downtime.

Other settings to consider:
For memory-intensive containers to run faster by giving more access to allocated memory.
```
"default-shm-size": "64M"
```
Isolate containers with a user namespace.
```
"userns-remap": "<uid>:<gid>"
```

- Redis:
Based on  the official image **redis:6.0.5-alpine3.12**.

> Refering to redis persistent storage instructions on docker hub.
```
$ docker run --name some-redis -d redis redis-server --appendonly yes
```
If persistence is enabled, data is stored in the `VOLUME /data`, which can be used with `--volumes-from some-volume-container` or `-v /docker/host/dir:/data`.

- [Resoure Quotas:](../master/k8s/01-resource-quota.yml)
Setup a few quotas related to **pods** and **nodeports**.

Other settings to consider for limiting cpu and memory:
```
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```
- [Redis deployment:](../master/k8s/02-redis.yml)
Used **hostPath** for redis volume.

- [Demo-app deployment:](../master/k8s/03-demo-app.yml)
Setup the liveness probe.


## Sources:

### Sysctl:

1. /etc/sysctl.conf
2. [SYN cookies](http://lwn.net/Articles/277146/)
3. [SYN packet handling in the wild](https://blog.cloudflare.com/syn-packet-handling-in-the-wild/)
4. [Sysctl tuning on Linux](https://blog.confirm.ch/sysctl-tuning-linux/)
5. [Understanding vm.swappiness](https://linuxhint.com/understanding_vm_swappiness/)
6. [Setting File Handles](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/tuning_and_optimizing_red_hat_enterprise_linux_for_oracle_9i_and_10g_databases/chap-oracle_9i_and_10g_tuning_guide-setting_file_handles)
7. [The ip_local_port_range parameters](https://tldp.org/LDP/solrhe/Securing-Optimizing-Linux-RH-Edition-v1.3/chap6sec70.html)
8. [The Tuned Project](https://tuned-project.org/)
9. [Learning Linux Security and LPIC-3 303](https://www.youtube.com/playlist?list=PLtGnc4I6s8dsaWzthjdXRY19olDJ-eFB-)
10. [Network Performance Tuning](https://www.youtube.com/watch?v=ZYCKSN4xf84)
11. [Jason Cook on TCP Tuning for the Web at Linux Conference Australia 2014](https://www.youtube.com/watch?v=gfYYggNkM20)
12. [Improving Network Performance](https://pubs.vmware.com/continuent/tungsten-replicator-3.0/performance-networking.html)

### Docker daemon:

1. [Docker logging best practices](https://www.datadoghq.com/blog/docker-logging/)
2. [Keep containers alive during daemon downtime](https://docs.docker.com/config/containers/live-restore/)
3. [Isolate containers with a user namespace](https://docs.docker.com/engine/security/userns-remap/)

### Kubernetes:

1. [Kubernetes Tutorial for Beginners](https://www.youtube.com/playlist?list=PLy7NrYWoggjwPggqtFsI_zMAwvG0SqYCb)
2. [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
3. [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
4. [Configure Quotas for API Objects](https://kubernetes.io/docs/tasks/administer-cluster/quota-api-object/)
5. [Volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
6. [Microk8s](https://microk8s.io/)
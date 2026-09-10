Ceph Tutorial: From Fundamentals to Production Basics

Ceph is an open-source distributed storage platform designed for scalability, fault tolerance, and high performance. It provides object storage, block storage, and file storage from a single clustered system.

This tutorial walks through Ceph architecture, installation, deployment, storage types, operations, monitoring, troubleshooting, and best practices.

1. What Is Ceph?

Ceph is a software-defined storage system that distributes data across many servers while automatically handling replication, recovery, balancing, and scaling.

Ceph supports:

    Object storage (S3/Swift compatible)
    Block storage (RBD for virtual machines)
    File storage (CephFS)


Key features:

    Horizontally scalable
    No single point of failure
    Self-healing
    Strong consistency
    Commodity hardware support


Common use cases:

    OpenStack storage backend
    Kubernetes persistent storage
    Backup systems
    Large-scale data lakes
    Media and AI workloads


2. Ceph Architecture

A Ceph cluster contains several daemon types.

MON (Monitor)

Maintains cluster maps and quorum.

Responsibilities:

    Authentication
    Cluster membership
    Health state


Usually deployed in odd numbers:

    3 MONs minimum
    5 for larger clusters


OSD (Object Storage Daemon)

Stores actual data on disks.

Responsibilities:

    Data replication
    Recovery
    Rebalancing


Each storage disk normally runs one OSD.

MGR (Manager)

Provides monitoring and metrics.

Responsibilities:

    Dashboard
    REST APIs
    Prometheus integration


MDS (Metadata Server)

Used only for CephFS.

Responsibilities:

    File metadata handling
    Directory structures
    Permissions


RGW (RADOS Gateway)

Provides object storage APIs.

Supports:

    Amazon S3
    OpenStack Swift


3. How Ceph Stores Data

Ceph uses:

    RADOS (Reliable Autonomic Distributed Object Store)
    CRUSH algorithm


Unlike traditional storage systems, Ceph does not rely on centralized metadata for data placement.

CRUSH Algorithm

CRUSH determines:

    Where objects are stored
    Replication placement
    Failure domain awareness


Advantages:

    No lookup bottlenecks
    Efficient scaling
    Predictable placement


4. Ceph Storage Types

Object Storage

Accessed using:

    S3 API
    Swift API


Used for:

    Backups
    Media storage
    Cloud-native apps


Service:

    RGW


Block Storage (RBD)

Provides virtual disks.

Used for:

    Virtual machines
    Kubernetes volumes
    Databases


Features:

    Thin provisioning
    Snapshots
    Cloning


File Storage (CephFS)

POSIX-compliant distributed filesystem.

Used for:

    Shared directories
    HPC workloads
    AI pipelines


Requires:

    MDS daemons


5. Lab Environment

Recommended test cluster:





Node


	

Role






node1


	

MON, MGR






node2


	

OSD






node3


	

OSD





Minimum requirements:

    Linux (Ubuntu/RHEL)
    4 GB RAM per node minimum
    SSD/NVMe preferred
    Time synchronization enabled


6. Installing Ceph with cephadm

Modern Ceph deployments use cephadm.

Example uses Ubuntu 22.04.

Step 1: Install Dependencies

Run on all nodes:

sudo apt update
sudo apt install -y podman lvm2 chrony curl


Step 2: Install cephadm

curl --silent --remote-name --location \
https://download.ceph.com/rpm-reef/el9/noarch/cephadm

chmod +x cephadm
sudo mv cephadm /usr/local/bin/


Verify:

cephadm version


Step 3: Bootstrap Cluster

Run on bootstrap node:

sudo cephadm bootstrap --mon-ip <NODE1_IP>


Example:

sudo cephadm bootstrap --mon-ip 192.168.1.10


This creates:

    MON
    MGR
    Dashboard
    Initial configuration


Step 4: Access Dashboard

Get credentials:

sudo cephadm shell -- ceph dashboard \
ac-user-show admin


Dashboard URL:

https://<node-ip>:8443


Step 5: Add Hosts

Copy Ceph SSH key:

ssh-copy-id -f -i /etc/ceph/ceph.pub root@node2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@node3


Add hosts:

ceph orch host add node2 192.168.1.11
ceph orch host add node3 192.168.1.12


Step 6: Add OSDs

Discover disks:

ceph orch device ls


Deploy OSDs:

ceph orch apply osd --all-available-devices


7. Checking Cluster Health

View status:

ceph -s


Example output:

cluster:
  health: HEALTH_OK


Detailed health:

ceph health detail


View OSDs:

ceph osd tree


8. Understanding Pools

Pools are logical storage containers.

Create a pool:

ceph osd pool create mypool 128


List pools:

ceph osd lspools


Set replication:

ceph osd pool set mypool size 3


Important settings:

    size = replica count
    min_size = minimum replicas required


9. Using Ceph Block Storage (RBD)

Create Pool

ceph osd pool create rbdpool 128
rbd pool init rbdpool


Create Image

rbd create mydisk --size 10G --pool rbdpool


List images:

rbd ls rbdpool


Map Image

sudo rbd map mydisk --pool rbdpool


Format filesystem:

sudo mkfs.ext4 /dev/rbd0


Mount:

sudo mount /dev/rbd0 /mnt


10. Using CephFS

Create Filesystem

ceph fs volume create cephfs


Check status:

ceph fs status


Mount CephFS

Install client:

sudo apt install ceph-common


Mount:

sudo mount -t ceph \
<mon-ip>:/ /mnt/cephfs \
-o name=admin,secret=<key>


11. Using Object Storage (RGW)

Deploy RGW:

ceph orch apply rgw myrgw


Create user:

radosgw-admin user create \
--uid=testuser \
--display-name="Test User"


Output contains:

    access_key
    secret_key


Use with:

    AWS CLI
    S3 SDKs
    MinIO clients


12. Snapshots and Clones

RBD Snapshot

Create snapshot:

rbd snap create rbdpool/mydisk@snap1


List snapshots:

rbd snap ls rbdpool/mydisk


Rollback:

rbd snap rollback rbdpool/mydisk@snap1


13. Replication and Recovery

Ceph automatically:

    Replicates data
    Detects failures
    Rebalances data


Test failure:

systemctl stop ceph-osd@0


Check health:

ceph -s


Ceph redistributes data automatically.

14. Monitoring Ceph

Useful commands:

ceph -s
ceph df
ceph osd df
ceph orch ps


Dashboard provides:

    Cluster health
    OSD usage
    Performance graphs
    Alerts


Prometheus + Grafana are commonly integrated.

15. Ceph Networking

Ceph often uses two networks.

Public Network

Client traffic:

    VM access
    User operations


Cluster Network

Internal traffic:

    Replication
    Recovery


Example config:

public_network = 192.168.1.0/24
cluster_network = 10.0.0.0/24


16. CRUSH Map Basics

CRUSH controls data placement.

Failure domains:

    host
    rack
    row
    datacenter


Example:

    Replicas distributed across different hosts


View CRUSH tree:

ceph osd crush tree


17. Authentication

Ceph uses cephx authentication.

Create client:

ceph auth get-or-create client.backup


Capabilities define permissions.

Example:

    Read-only pool access
    Specific filesystem access


18. Performance Tuning

Important areas:

Hardware

Best practices:

    NVMe for WAL/DB
    SSDs preferred
    10GbE+ networking


BlueStore

Default modern backend.

Advantages:

    Better performance
    Lower overhead


Placement Groups (PGs)

PGs affect distribution.

Check autoscaler:

ceph osd pool autoscale-status


19. Common Troubleshooting

HEALTH_WARN

Check:

ceph health detail


Common causes:

    Full disks
    Down OSDs
    Clock skew


OSD Down

Restart:

systemctl restart ceph-osd@<id>


Full Cluster

Check usage:

ceph df


Add:

    More disks
    More OSDs


Slow Operations

Investigate:

    Network latency
    Disk bottlenecks
    Recovery load


20. Upgrading Ceph

Check version:

ceph versions


Upgrade with orchestrator:

ceph orch upgrade start --image <image>


Always:

    Read release notes
    Upgrade incrementally
    Verify health before upgrade


21. Backup Strategies

Ceph is fault-tolerant, but not a backup solution alone.

Use:

    RBD snapshots
    Object versioning
    External backups
    Cross-cluster replication


22. Security Best Practices

Recommendations:

    Use TLS
    Isolate cluster network
    Rotate keys
    Restrict admin access
    Enable firewall rules


23. Ceph in Kubernetes

Ceph integrates with Kubernetes using:

    Rook
    Ceph CSI drivers


Provides:

    Persistent volumes
    Dynamic provisioning
    Snapshot support


Rook automates:

    Deployment
    Scaling
    Upgrades


24. Production Best Practices

Hardware

    Separate OS and OSD disks
    SSD/NVMe preferred
    ECC RAM


Cluster Size

Minimum:

    3 MONs
    3 OSD nodes


Networking

    Redundant switches
    Jumbo frames if validated
    Bonded interfaces


Monitoring

Integrate:

    Prometheus
    Grafana
    Alertmanager


25. Example Architecture

Typical production cluster:

Clients
   |
Load Balancer
   |
+----------------------+
| MON/MGR Nodes        |
+----------------------+
       |
+----------------------+
| OSD Storage Nodes    |
| HDD + NVMe WAL/DB    |
+----------------------+
       |
Replication Network


26. Essential Commands Cheat Sheet

Cluster status:

ceph -s


OSD tree:

ceph osd tree


Pool list:

ceph osd lspools


Create pool:

ceph osd pool create testpool 128


RBD list:

rbd ls


Filesystem status:

ceph fs status


Device list:

ceph orch device ls


27. Learning Path

Recommended progression:

    Understand Ceph architecture
    Build a 3-node lab
    Practice pool management
    Use RBD with VMs
    Deploy CephFS
    Configure RGW
    Learn monitoring and recovery
    Explore Kubernetes integration
    Study CRUSH and performance tuning
    Design production deployments


28. Recommended Resources

Official documentation:

    https://docs.ceph.com/


Community:

    Ceph mailing lists
    Ceph Slack
    GitHub repositories


Useful tools:

    cephadm
    Rook
    Prometheus
    Grafana


29. Final Notes

Ceph is powerful because it combines:

    Scalability
    Reliability
    Flexibility


The most important concepts to master are:

    OSDs
    Pools
    CRUSH
    Replication
    Recovery behavior


A small lab cluster is the fastest way to gain practical understanding. Start with block storage, then expand into CephFS and object storage as you become comfortable with cluster operations.
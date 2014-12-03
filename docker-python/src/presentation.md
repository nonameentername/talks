# Python in Docker

---

# About me
Werner Mendizabal
-----------------

- OpenStack Developer at Rackspace
    - OpenStack Keystone - https://github.com/openstack/keystone

- IRC - nonameentername on Freenode

- Twitter @nonameentername

- GitHub - https://github.com/nonameentername

---

# What is docker?
![docker](images/docker-logo.png)

- Docker is an open platform for developers and sysadmins to build, ship, and run distributed applications

    - https://www.docker.com

---

# Docker Architecture
![docker](images/docker-filesystems.png)

---

# Fig
![docker](images/fig-logo.png)

- Fast, isolated development environments using Docker
    - http://www.fig.sh
    - Install: pip install fig

---

# Dockerfile

    !bash
    #
    #
    # VERSION               1.0.0
    FROM ubuntu:12.04

    RUN install.sh
    VOLUME ["/schema", "/data"]

---

# fig.yml

---

# Docker images
Images stored in a private docker registry:

- application-base-image
- backend-base-image
- nexus
- riak

Images built on demand:

- application
- backend

---

# Docker images

Dockerfile

    !bash
    # backend-base-image
    #
    # VERSION               1.0.0
    FROM ubuntu:12.04

    RUN install.sh
    VOLUME ["/schema", "/data"]

Dockerfile

    !bash
    # backend
    #
    # VERSION               1.0.0
    FROM backend-base-image

    ADD /schema /schema
    ADD /data /data

---

# Docker images

Dockerfile

    !bash
    # application-base-image
    #
    # VERSION               1.0.0
    FROM ubuntu:12.04

    RUN install.sh
    VOLUME ["/config", "/war"]

Dockerfile

    !bash
    # application
    #
    # VERSION               1.0.0
    FROM application-base-image

    ADD /config /config
    ADD /war /war

---

# Architecture of Docker solution
bottle service:

- docker-py
- riak
- angularjs
- command line client

---

# Architecture of Docker solution

![system](images/system.png)

---

# Architecture of Docker solution
    !python
    @get('/IDaaS/versions')
    @get('/IDaaS/versions/<version>')
    @post('/IDaaS/apps')
    @get('/IDaaS/apps')
    @get('/IDaaS/apps/<application_id>')
    @get('/IDaaS/hosts/<host_id>/log')
    @delete('/IDaaS/apps/<application_id>')
    @get('/')
    @get('/static/<path:path>')

---

# Architecture of Docker solution
    !python
    from docker import Client

    def get_riak_ip():
        docker = Client()
        for container in docker.containers():
            container_id = container['Id']
            info = docker.inspect_container(container_id)
            if info['Config']['Image'] == 'riak':
                return info['NetworkSettings']['IPAddress']
        return riak_instance['ip']

---

# Architecture of Docker solution
    !python
    from riak import RiakClient

    def create_instance(version, tag):
        riak = RiakClient(host=get_riak_ip())
        apps = riak.bucket('apps')

        data = {
            'version': version,
            'tag': tag
        }

        application = apps.new(data=json.dumps(data))
        application.store()

        response = docker.create_container("application")
        docker.start(response)

        info = docker.inspect_container(response)
        return info['Name']

---

# Identity CI/CD pipeline
    for github repository
    create a new branch
    submit pull request
    jenkins job started via github hook
    jenkins creates new artifact nexus
    jenkins creates new docker instance of the database using nexus artifact
    jenkins runs test
    jenkins notifies github on success or failure of the job
    merge back into master
    jenkins merge job

---

# Demo
Docker time

![golang](images/gopher.png)

---

# Future Improvements
Run service on a cluster of nodes (Apache Mesos?)

Allow more complex deployments

Recover from node failure: spin up new nodes and assign same ip (Open vSwitch)

![mesos](images/mesos.png)

---

# QA
![questions](images/questions.png)


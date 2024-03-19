# Docker config for Multiuser dl platform;
## Directory tree:
- ```markdown
└── office
    ├── stus
    |   ├── docker-compose.yml
    |   └── data
    |       ├── stu1
    |       |   ├── conf
    |       |   ├── env
    |       |   └── workspace 
    |       └── stu2
    |           ├── conf
    |           ├── env
    |           └── workspace 
    ├── scripts
    └── Dockerfile
```
## Usage:
- get into the directory where docker config file (like `docker-compose.yml`) is
- uncompress the apt files into the user conf directory
```shell
tar -zxvf ../scripts/apt.tar.gz -C data/stu1/conf
...
```
- build and run
```shell
docker-compose -f docker-compose.yml up -d
```
- get into the container(s) and set the password for them
```shell
docker exec -it container_name /bin/bash
passwd
```
- use ssh to connect the container(s)

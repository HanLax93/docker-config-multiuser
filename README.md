# Docker config for Multiuser dl platform
## Directory tree:
```markdown
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
- get into the directory where docker config file (like `docker-compose.yml` ) is and create the directory for stu's apt files
```shell
cd stus
mkdir -p data/stux/conf data/stux/envs data/stux/workspace
```
- uncompress the apt files into the user conf directory
```shell
tar -zxvf ../scripts/apt.tar.gz -C data/stux/conf
...
```
- build and run
```shell
docker-compose -f docker-compose.yml up -d
```
- change the owner of directories
```shell
docker exec -it -uroot container_name chown -R stu:sudo /home/stu
```
- start ssh service (everytime you restart the container(s))
```shell
docker exec -it -uroot container_name service ssh start
```
- use ssh to connect the container(s)
```shell
ssh -p x022 stu@ip
```
- when adding containers for users, just add more services reference to wxl2080Ti_base.yml and increase the stu_index

#!/bin/bash
#untar dependencies
tar xzvf /tmp/dependencies.tar.gz -C /tmp/ \
  && rm /tmp/dependencies.tar.gz \
  && chmod +x /tmp/dependencies/init4user.sh

# 保持会话
tail -f /dev/null

#!/bin/bash
set -x
time eksctl create cluster \
--name aug05 \
--version 1.17 \
--region us-west-2 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed
#--fargate \

#!/bin/bash
set -x
time eksctl create cluster \
--name eksctl-2-18 \
--version 1.14 \
--region us-west-2 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed

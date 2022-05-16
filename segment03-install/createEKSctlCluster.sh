#!/bin/bash
set -x
time eksctl create cluster \
--name apr7 \
--version 1.20 \
--region us-west-2 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 2 \
--nodes-min 1 \
--nodes-max 4 \
--managed 

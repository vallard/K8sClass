#!/bin/bash
set -x
time eksctl create cluster \
--name mar26 \
--version 1.15 \
--region us-west-2 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed

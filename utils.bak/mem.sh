#!/usr/bin/env bash

echo $(free -m | sed -n '2p' | awk '{print $2}')

# darigold_linux_patch

## Overview

This cookbook is used as a proof of concept for patching Linux.

## Process

1) Shutdown Running Application Services
2) Update Yum Repositories
3) Patch Linux OS
4) Reboot Server
5) Verify Patch was Successful
   -if failed) Rollback yum patch and reboot
   -if success) Exit process

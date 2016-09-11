#!/bin/bash
puma -b 'ssl://127.0.0.1:3000?key=./.ssl/localhost.key&cert=./.ssl/localhost.crt' -v

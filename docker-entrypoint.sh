#!/bin/sh

exec gosu nginx nginx -g "daemon off;"

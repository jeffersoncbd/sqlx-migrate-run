#!/bin/bash

sqlx database create
sqlx migrate run
sccache --show-stats

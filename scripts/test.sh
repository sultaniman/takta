#!/bin/bash
clear;
export MIX_ENV=test;
mix test --trace --color
export MIX_ENV=dev;

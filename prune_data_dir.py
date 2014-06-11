#!/usr/bin/python

import time
number = 2

while 1:
  number = number * number

  if number > 100000000000000000:
    number = 0
    time.sleep(1)

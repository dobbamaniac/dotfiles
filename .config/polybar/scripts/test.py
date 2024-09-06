#!/usr/bin/env python3

import i3ipc

i3 = i3ipc.Connection()

print(i3.get_marks())	

i3.main()


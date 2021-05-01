#!/usr/bin/env python3

import sys
import torch

assert sys.argv[1] in ('torch', 'cuda')

if sys.argv[1] == 'torch':
    print(torch.__version__)
else:
    if not torch.version.cuda: # cpu
        print('cpu')
    else:
        print('cu' + torch.version.cuda.replace('.', ''))


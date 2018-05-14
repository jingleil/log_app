#---coding:utf-8---
'''
Created on 2016��7��15��
@author: liangdongdong1
'''

import logging

logging.basicConfig(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='./logs/log_app.log',
                filemode='w')

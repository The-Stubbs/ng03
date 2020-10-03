# -*- coding: utf-8 -*-

def ToStr(s):
    if s: return str(s)
    else: return ''

def ToInt(s, defaultValue):
    if(s == "" or s == '' or s == None): return defaultValue
    i = int(float(s))
    if i == None:
        return defaultValue
    return i

def ToBool(s, defaultValue):
    if(s == "" or s == '' or s == None): return defaultValue
    i = int(float(s))
    if i == 0:
        return defaultValue
    return True

# -*- coding: utf-8 -*-

import sys
import subprocess
import ConfigParser
from flask import Flask,render_template,request,jsonify
from comm.logLevel import logging
from comm import gl 
import json

'''
Author: lijinglei
Contact: lijinglei1@jd.com
'''

reload(sys)
sys.setdefaultencoding('utf-8')

cmd_args = gl.cmd_args
app = Flask(__name__)

## 主页渲染
@app.route('/', methods=['GET','POST'])
def index():
    infos = None
    if request.method == 'GET':
        return render_template('index.html',infos=infos)
    elif request.method == 'POST': #获取POST请求的参数
        keys = str(request.form.get('keys')).strip()
	appname = str(request.form.get('appname'))
        print request.form
      
        if keys == '' :    
            cmd_args = ''
        else:
	    print gl.cmd_args
	    print appname+" "+keys
            cmd_args = gl.cmd_args  % (keys,appname,appname)
	    print repr(cmd_args)

        try: #开启进程，执行shell命令
            infos = subprocess.Popen(cmd_args, stdout=subprocess.PIPE, shell=True).stdout.readlines()
            if len(infos) == 0:
               infos=["未搜到匹配的内容"] 
            return render_template('index.html',appName=appname,infos=infos,key=keys)
        except Exception, _ex:
            return '您的搜索条件，未匹配到对应的日志' + str(_ex)
    else:
        return "对不起，请求的存在异常~"

## 查询日志信息
@app.route('/_searchLog', methods=['GET','POST'])
def searchLog():
    infos = None
    data = json.loads(request.args.get('appKey'));
    appname = data[0];
    keys = data[1];
    print '>>>: appname=%s, keys=%s' % (appname,keys)
    #以下为冗余代码，暂时保留，实际调用的是GET方法
    if request.method == 'POST':
	print 'MMMMM: method is get'
        return render_template('index.html',infos=infos)
    elif request.method == 'GET': #获取POST请求的参数
        #keys = str(request.args.get('keys'))
	#appname = str(request.args.get('appname'))
      
        if keys == '' :    
            cmd_args = ''
        else:
	    print gl.cmd_args
	    print appname+" "+keys
            cmd_args = gl.cmd_args  % (keys,appname,appname)
	    print repr(cmd_args)

        try: #开启进程，执行shell命令
            infos = subprocess.Popen(cmd_args, stdout=subprocess.PIPE, shell=True).stdout.readlines()
            if len(infos) == 0:
               infos=["未搜到匹配的内容"] 
        except Exception, _ex:
            infos='您的搜索条件，未匹配到对应的日志' + str(_ex)
    else:
        infos="对不起，请求的存在异常~"
    return jsonify(infos)

## 查看内存信息
@app.route('/_checkMem')
def checkMem():
    infos = None
    if request.method == 'GET':
        cmd_checkmem = gl.cmd_checkmem
        try: #开启进程，执行shell命令
            print repr(cmd_checkmem)
            infos = subprocess.Popen(cmd_checkmem, stdout=subprocess.PIPE, shell=True).stdout.readlines()
            for info in infos:
                print info
            #return json.dumps(infos)
            return jsonify(infos)
        except Exception, _ex:
            return 'command execute error' + str(_ex)

    elif request.method == 'POST': #获取POST请求的参数
        keys = str(request.form.get('keys'))
	appname = str(request.form.get('appname'))
      
        print gl.cmd_checkmem
        cmd_checkmem = gl.cmd_checkmem

        try: #开启进程，执行shell命令
            infos = subprocess.Popen(cmd_checkmem, stdout=subprocess.PIPE, shell=True).stdout.readlines()
            for info in infos:
                print info
            #return json.dumps(infos)
            return jsonify(infos)
        except Exception, _ex:
            return 'command execute error' + str(_ex)
    else:
        return "对不起，请求的存在异常~"

## 重启应用
@app.route('/_restartApp')
def restartApp():
    infos = None
    data = json.loads(request.args.get('appKey'));
    appKey = data[0];
    operation = data[1];
    try: #开启进程，执行shell命令
    	cmd_rstApp = gl.cmd_rstApp % (appKey, operation);
        print repr(cmd_rstApp)
        infos = subprocess.Popen(cmd_rstApp, stdout=subprocess.PIPE, shell=True).stdout.readlines()
        for info in infos:
            print info
        return jsonify(infos)
    except Exception, _ex:
        infos = ['command execute error' + str(_ex)]
        print 'command execute error' + str(_ex)
        return jsonify(infos)

## 清理内存
@app.route('/_cleanMem')
def cleanMem():
    infos = None
    try: #开启进程，执行shell命令
    	cmd_cleanMem = gl.cmd_cleanMem;
        print repr(cmd_cleanMem)
        infos = subprocess.Popen(cmd_cleanMem, stdout=subprocess.PIPE, shell=True).stdout.readlines()
        for info in infos:
            print info
        return jsonify(infos)
    except Exception, _ex:
        infos = ['command execute error' + str(_ex)]
        print 'command execute error' + str(_ex)
        return jsonify(infos)

## 获取日志url
@app.route('/_loadLog')
def loadLog():
    infos = None
    data = json.loads(request.args.get('appKey'));
    appName = data[0];
    print '>>>>>> %s' %  appName
    try: #开启进程，执行shell命令
    	cmd_checkLog = gl.cmd_checkLog % (appName)
        print repr(cmd_checkLog)
        infos = subprocess.Popen(cmd_checkLog, stdout=subprocess.PIPE, shell=True).stdout.readlines()
        for info in infos:
            print info
        return jsonify(infos)
    except Exception, _ex:
        infos = ['command execute error' + str(_ex)]
        print 'command execute error' + str(_ex)
        return jsonify(infos)

## 获取终端url
@app.route('/_loadTty')
def loadTty():
    infos = None
    try: #开启进程，执行shell命令
    	cmd_loadTty = gl.cmd_loadTty
        print repr(cmd_loadTty)
        infos = subprocess.Popen(cmd_loadTty, stdout=subprocess.PIPE, shell=True).stdout.readlines()
        for info in infos:
            print info
        return jsonify(infos)
    except Exception, _ex:
        infos = ['command execute error' + str(_ex)]
        print 'command execute error' + str(_ex)
        return jsonify(infos)

## 应用请求，渲染请求页
@app.route('/app/<appName>', methods=['GET','POST'])
def appIndex(appName):
    infos = None
    print '>>>> appname: %s' % appName
    infos=["未搜到匹配的内容"] 
    return render_template('appIndex.html',infos=infos)

#加载配置到内存
def _init_config():
    cf = ConfigParser.ConfigParser()
    cf.read("web.conf")
    gl.cmd_args = cf.get("cmd","args")
    gl.cmd_checkmem = cf.get("cmd","checkmem")
    gl.cmd_rstApp = cf.get("cmd","rstApp")
    gl.cmd_cleanMem = cf.get("cmd","cleanMem")
    gl.cmd_checkLog = cf.get("cmd","checkLog")
    gl.cmd_loadTty = cf.get("cmd","loadTty")

if __name__ == '__main__':
    _init_config()
    app.run(host='0.0.0.0',port=8028,threaded=True,debug=True)
    

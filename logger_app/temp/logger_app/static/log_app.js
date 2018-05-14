function markText(text, flag, bgCor, fgCor){ 
            var style=' style="background-color:'+bgCor+';color:'+fgCor+';" '
            var o=document.createElement('span');
            var str=''; 
            var re=new RegExp('('+flag+')', 'gi');
            str=text.replace(re, '<span '+style+'>$1</span>');
            o.innerHTML=str;
            return o;
}


function fHl(o, flag, rndColor, url){
        var bgCor=fgCor='';
        if(rndColor=="normal"){
                // bgCor='#0FF';
                bgCor='#00FF00';
                fgCor='black';
        } else if (rndColor=='error'){
                // bgCor='#F0F';
                bgCor='#FF0000';
                fgCor='black';
        } else {
                bgCor=fRndCor(10, 20);
                fgCor=fRndCor(230, 255);
        }       

        var re=new RegExp(flag, 'i');

        for(var i=0; i<o.childNodes.length; i++){
                var o_=o.childNodes[i];
                var o_p=o_.parentNode;
                if(o_.nodeType==1) {
                        fHl(o_, flag, rndColor, url);
                } else if (o_.nodeType==3) {
                        if(!(o_p.nodeName=='A')){
                                if(o_.data.search(re)==-1)continue;
                                        var temp=fEleA(o_.data, flag);
                                        o_p.replaceChild(temp, o_);
                        }
                }
        }

        //------------------------------------------------
        function fEleA(text, flag){
            var style=' style="background-color:'+bgCor+';color:'+fgCor+';" '
            var o=document.createElement('span');
            var str='';
            var re=new RegExp('('+flag+')', 'gi');
            if(url){
                str=text.replace(re, '<a href="'+url+
                '$1"'+style+'>$1</a>');
            } else {
                str=text.replace(re, '<span '+style+'>$1</span>');
            }
            o.innerHTML=str;
            return o;
        }

        //------------------------------------------------
        function fRndCor(under, over){
            if(arguments.length==1){
                var over=under;
                    under=0;
            }else if(arguments.length==0){
                var under=0;
                var over=255;
            }
            function fRandomBy(under, over){
                switch(arguments.length){
                    case 1: return parseInt(Math.random()*under+1);
                    case 2: return parseInt(Math.random()*(over-under+1) + under);
                    default: return 0;
                }
            }
            function padNum(str, num, len){
                var temp=''
                for(var i=0; i<len;temp+=num, i++);
                return temp=(temp+=str).substr(temp.length-len);
            }
            var r=fRandomBy(under, over).toString(16);
                r=padNum(r, r, 2);
            var g=fRandomBy(under, over).toString(16);
                g=padNum(g, g, 2);
            var b=fRandomBy(under, over).toString(16);
                b=padNum(b, b, 2);
                //defaultStatus=r+' '+g+' '+b
            return '#'+r+g+b;
       }
}

function accesstty(url) {
        window.open(url)
}

if (!String.prototype.trim) {

 /*----------------------------------------
  * 清除字符串左侧空格，包含换行符、制表符
  * ---------------------------------------*/
 String.prototype.triml = function () {
  return this.replace(/^[\s\n\t]+/g, "");
 }

 /*----------------------------------------
  * 清除字符串右侧空格，包含换行符、制表符
  *----------------------------------------*/
 String.prototype.trimr = function () {
  return this.replace(/[\s\n\t]+$/g, "");
 }
 /*---------------------------------------
  * 清除字符串两端空格，包含换行符、制表符
  *---------------------------------------*/
 String.prototype.trim = function () {
  return this.triml().trimr();
 }

}

function checkform(){
        if(document.getElementById('keys').value.trim()==""||document.getElementById('keys').value.length==0){
                alert('请输入查询关键字,不能为空~');
                document.getElementById('keys').focus();
                return false;
        }
}

function testShowDiv(content) {
        alert('testShowDiv'+content)
	//document.getElementById("showDiv").style.display ="none";  

}

function getAppName() {
	var appname=""
        if (document.getElementsByName('appname').length>0) {
                var App=document.getElementsByName('appname')[0].selectedIndex;
                appname=$("#appName option:selected").val();
        	return appname
        } else {
                var pstr=document.location.pathname
                appname=pstr.substring(pstr.lastIndexOf('/')+1)
                //var appname=pstr.substring(pstr.search('app')+4)
        }
	// alert(appname)
        return appname
}

$(function() {

	$('#checkmem').bind('click', function() {
		$.getJSON('/_checkMem', {}, function(data) {
		<!-- alert("Data: \n" + data + "\nStatus: " + status); -->
		memInfo=data[1].split(/\s+/);
		alert("\n内存总量(M)："+memInfo[1]+"    "+"剩余内存(M)："+memInfo[3]);
		var memli = document.createElement("li");
		var info="<b>内存使用详细：</b><br/>    "
		for(var i=0;i<data.length;i++) {
				if(i==4){
						info=info+"<b>磁盘使用详细：</b><br/>"
				}
				info=info+data[i]+"<br/>";
		}
		memli.innerHTML=info;
		$('ul#showlog').empty();
		$('ul#showlog').append(memli);
	  });
	  return false;
	});

	$('#restartapp').bind('click', function() {
		// var App=document.getElementsByName('appname')[0].selectedIndex;
		// var appname=$("#appName option:selected").val();
		appname=getAppName()

		var r=confirm("确定重启"+appname+"?");
		if (r==true)
		{
				$.getJSON('/_restartApp', { appKey: JSON.stringify([appname,"restart"])}, function(data) {
						/*
						$('ul#showlog').empty();
						var memli = document.createElement("li");
						var info="<b>重启详细信息：</b><br/>    "
						for(var i=0;i<data.length;i++) {
								info=info+data[i]+"<br/>";
						}
						memli.innerHTML=info;
						$('ul#showlog').append(memli);
						*/
						alert("\n重启信息："+data);
						});
						return false;
				}
		else
		{
		}
		
	});

	$('#startapp').bind('click', function() {
		// var App=document.getElementsByName('appname')[0].selectedIndex;
		// var appname=$("#appName option:selected").val();
		var appname=getAppName()

		var r=confirm("确定启动"+appname+"?");
		if (r==true)
		{
				$.getJSON('/_restartApp', { appKey: JSON.stringify([appname,"start"])}, function(data) {
						/*
						$('ul#showlog').empty();
						var memli = document.createElement("li");
						var info="<b>启动详细信息：</b><br/>    "
						for(var i=0;i<data.length;i++) {
								info=info+data[i]+"<br/>";
						}
						memli.innerHTML=info;
						$('ul#showlog').append(memli);
						*/
						alert("启动信息："+data);
						});
						return false;
				}
		else
		{
		}
		
	});

	$('#stopapp').bind('click', function() {
		// var App=document.getElementsByName('appname')[0].selectedIndex;
		// var appname=$("#appName option:selected").val();
		var appname=getAppName()

		var r=confirm("确定停止"+appname+"?");
		if (r==true)
		{
				$.getJSON('/_restartApp', { appKey: JSON.stringify([appname,"stop"])}, function(data) {
						/*
						$('ul#showlog').empty();
						var memli = document.createElement("li");
						var info="<b>停止详细信息：</b><br/>    "
						for(var i=0;i<data.length;i++) {
								info=info+data[i]+"<br/>";
						}
						memli.innerHTML=info;
						$('ul#showlog').append(memli);
						*/
						alert("\n停止信息："+data);
						});
						return false;
				}
		else
		{
		}
		
	});

	$('#cleanmem').bind('click', function() {
		$.getJSON('/_cleanMem', { }, function(data) {
				alert(data+"\n点击\"内存磁盘信息\"按钮，查看最新内存信息。");
				});
				return false;
	});

	$('#loadtty').bind('click', function() {
		$.getJSON('/_loadTty', { }, function(data) {
				var ifrm=document.createElement("iframe");
				var ifrmcss="width:100%;height:100%;frameborder:0;clear:both;scrolling:no";
				var iurl=data;
				ifrm.src=iurl;
				ifrm.style=ifrmcss;
				$("div.wd100 ul").empty();
				$("div.wd100 ul").height(screen.availHeight-200);
				$("div.wd100 ul").append(ifrm);
				});
				return false;
	});

	$('#loadlog').bind('click', function() {
		// var App=document.getElementsByName('appname')[0].selectedIndex;
		// var appname=$("#appName option:selected").val();
		var appname=getAppName()

		$.getJSON('/_loadLog', { appKey: JSON.stringify([appname])}, function(data) {
				if (data.length==0) {
						alert("\n未找到该应用日志！");
				}
				var ifrm=document.createElement("iframe");
				var ifrmcss="width:100%;height:100%;frameborder:0;clear:both";
				var iurl=data;
				ifrm.src=iurl;
				ifrm.style=ifrmcss;
				ifrm.scrolling="no";
				$("div.wd100 ul").empty();
				$("div.wd100 ul").css("height",screen.availHeight-200);
				$("div.wd100 ul").append(ifrm);
				});
				return false;
	});

	$('#searchlog').bind('click', function() {
				var keys=document.getElementById('keys').value.trim();
				if(keys==""||keys.length==0){
						alert('请输入查询关键字，不能为空~');
						document.getElementById('keys').focus();
						return false;
				}
				//var appname=$("#appName").val();
				var appname=getAppName();
				//testShowDiv('开始请求数据，请耐心等待...');
				disappear();
				$('ul#showlog').empty();
				//loadHarder();
				$.getJSON('/_searchLog', {appKey: JSON.stringify([appname,keys])}, function(data) {
						/*memInfo=data[1].split(/\s+/);
						*/
						//$('ul#showlog').empty();
						for(var i=0;i<data.length;i++) {
								var memli = document.createElement("li");
								memli.innerHTML=data[i];
								// markText(memli, keys,'red','black')
								// fHl(memli, keys, 'normal');
								// fHl(memli, 'exception', 'error');

								$('ul#showlog').append(memli);
						}
						//testShowDiv('数据加载完成，...');
						fHl(document.body, keys, 'normal');
						fHl(document.body, 'exception', 'error');
						//loadHarder();
						disappear();

				});
				//fHl(document.body, keys, 'normal');
				//fHl(document.body, 'exception', 'error');
	});

});

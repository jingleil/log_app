//定义全局变量
//小球坐标
ballX=500;
ballY=200;
//小球在x,y轴移动的方向
directX=2;
directY=1;
//小球移动
function ballMove(){
	//小球移动
	ballX+=2*directX;
	//ballY+=2*directY;
	//同时修改小球的top 和width
	document.getElementById('div2').style.left=ballX+'px';
	//document.getElementById('div2').style.top=ballY+'px';
	//offsetwidth在JS中是获取元素的宽,对应的还有offsetHeight
	//判断转向, learInterval(i);
	curX=ballX+document.getElementById('div2').offsetWidth;
	cmpWidth=document.getElementById('showDiv').offsetWidth;
	//curY=ballY+document.getElementById('div2').offsetHeight;
	if(curX>=cmpWidth*0.7 ||ballX<=cmpWidth*0.3){
		baseX=cmpWidth*0.3;
		directX=-directX;
	}
	/*
	if(curY>=document.getElementById('showDiv').offsetHeight || ballY<=0){
		directY=-directY;
	}
	*/
}

//定时器
//var i=setInterval("ballMove()",40);
intvJ=0;

function disappear() {
	//document.getElementById('div2').style.display = document.getElementById('div2').style.display=="none"?"block":"none";
	if ( document.getElementById('div2').style.display=="none" ) {
		document.getElementById('div2').style.display="block";
		document.getElementById('showlog').style.display="none";
		intvJ=setInterval("ballMove()",100);
	} else {
		window.clearInterval(intvJ);
		document.getElementById('div2').style.display="none"
		document.getElementById('showlog').style.display="block"
	}		
}

function loadHarder() {
	/* if (document.getElementById('showlog').style.backgroundImage=="none") {
		document.getElementById('showlog').style.backgroundImage="url(../static/load6.gif)";
	} else {
		document.getElementById('showlog').style.backgroundImage="none";
	}
	*/

	if ( document.getElementById('div3').style.display=="none" ) {
		document.getElementById('div3').style.display="block";
	} else {
		document.getElementById('div3').style.display="none";
	}
}

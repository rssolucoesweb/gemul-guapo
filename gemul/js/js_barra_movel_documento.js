var agent = navigator.userAgent.toLowerCase();
var is_ns  = ((agent.indexOf('mozilla')!=-1) && ((agent.indexOf('spoofer')==-1) 
                && (agent.indexOf('compatible') == -1)));
var is_ie   = (agent.indexOf("msie") != -1);
var LocX=0
var LocY=0

function menuFix() {
	if (document.layers){
	menuBlock=document.documento;
	menuBlock.visibility="show";
	LocX=window.pageXOffset;
	LocY=window.pageYOffset;
	}
	if (document.all){
	menuBlock=documento.style;
	menuBlock.visibility="visible";
	LocX=document.body.scrollLeft;
	LocY=document.body.scrollTop;
	}
                  if (document.getElementById && is_ns){
                  menuBlock=document.getElementById('documento');
                  menuBlock.style.visibility="visible";
                  LocX=window.pageXOffset;
                  LocY=window.pageYOffset;
	}
	if(document.getElementById && is_ns)
	{
	menuBlock.style.left= (LocX+645);
	menuBlock.style.top= (LocY+0);
	}
	else
		if(document.layers||document.all){
            menuBlock.left= (LocX+700);
			menuBlock.top= (LocY+130);		
		}
}

if(document.layers||document.all||document.getElementById && is_ns){
	setInterval("menuFix()",150)
}

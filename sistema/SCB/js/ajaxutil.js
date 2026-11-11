
// JavaScript Document
//Tenta criar o objeto xmlHTTP
try{
    xmlhttp = new XMLHttpRequest();
}
catch(ee)
{
    try
	{
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
	catch(e)
	{
        try{
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
		catch(E)
		{
            xmlhttp = false;
        }
    }
}

//Fila de conexões
var fila=[]
var ifila=0
var GET    					   = 1;
var POST   					   = 2;
var AJAX_METHOD 			   = POST;
var AJAX_SEND_FIELDS_DISABLEDS = false;
var AJAX_SYNC				   = true;

function ExecAjax(id,url,parametros,mensagem){
	var mensagem = mensagem == undefined ? 'Carregando...' : mensagem;	
	
	
	if (typeof id == 'string') {		
		var obj = document.getElementById(id);
		if (obj.tagName.toLowerCase() == 'select') {
			
			var option = document.createElement('option')
			option.setAttribute('id','ajax_load')
			option.value = 'ajax_load'
			option.text = mensagem;
			obj.innerHTML = '';
			obj.options[0] = option;
		}
	}
	else {
		obj = id;
	}
	
	if (!document.getElementById('spnLoading')){
		var span = document.createElement('span');
		if (mensagem != ""){
			span.innerHTML = mensagem + '&nbsp;<img src="../../images/loading.gif" align="absmiddle"></img>';
			span.id = 'spnLoading';
			span.className = 'aguarde';				
		}
		document.body.appendChild(span);
	}
    //Adiciona à fila
    fila[fila.length]=[obj,url,parametros];
    //Se não há conexões pendentes, executa
    if((ifila+1)==fila.length)ajaxRun();
}

//Executa a próxima conexão da fila
function ajaxRun(){
	var url;
	var parametros;
	if (typeof fila[ifila][1] == 'object')
	{
		url = fila[ifila][1].action;		
		parametros = montaParametros(fila[ifila][1],fila[ifila][2]);

	}
	else
	{
		url = fila[ifila][1];
		parametros = fila[ifila][2];
			
	}
	if (AJAX_METHOD == GET)
	{
		var url = fila[ifila][1].action + '?';
		xmlhttp.open("GET",url,true);
		xmlhttp.send(null);
	}
	else if (AJAX_METHOD == POST)
	{	
		parametros = parametros.replace(/ /g, "%20");
		xmlhttp.open("POST",url,true);
		xmlhttp.setRequestHeader('Content-Type','text/xml'); 
		xmlhttp.setRequestHeader('encoding','ISO-8859-1'); 
		xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		//xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=ISO-8859-1");		
		xmlhttp.setRequestHeader("Content-length", parametros == undefined ? 0 : parametros.length);
		//xmlhttp.setRequestHeader("Connection", "close");
		xmlhttp.send(parametros);

	}
	
    //Função para tratamento do retorno
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4){
			//alert( xmlhttp.responseText)
			if (typeof fila[ifila][0] == 'function') {		
				//fila[ifila][0](xmlhttp);		
				//alert('function' + xmlhttp.responseText)
				fila[ifila][0](xmlhttp);
			}
			else //preenche a combobox ou div
			{	
				if (fila[ifila][0].tagName.toLowerCase() == 'select') {					
					
					preencheCombo(xmlhttp.responseXML,fila[ifila][0]);
				}
				else {
					
					retorno=unescape(xmlhttp.responseText.replace(/\+/g," "))					
					
					fila[ifila][0].innerHTML=retorno;
				}				
			}
			if (document.getElementById('spnLoading'))
				document.getElementById('spnLoading').parentNode.removeChild(document.getElementById('spnLoading'));
			
            //Roda o próximo
            ifila++;
			//alert('ifila++' + ifila)			
			
            if(ifila<fila.length)
				setTimeout("ajaxRun()",20);
        }
    }
}

function preencheCombo(xml,combo) {
	var selecionado;
	selecionado = 0;
	
	if (xml!= null){
		if (xml.documentElement != null){
			//alert(' tagname ' + xml.getElementsByTagName(xml.documentElement.childNodes[0].tagName))
			var elementos = xml.getElementsByTagName(xml.documentElement.childNodes[0].tagName);
			var option;	
	
			for(i=0;i<elementos.length;i++) {
				option = document.createElement('option');
					
				option.value = elementos[i].childNodes[0].childNodes[0].nodeValue;
				option.text  = elementos[i].childNodes[1].childNodes[0].nodeValue;
				if (elementos[i].childNodes[2]!=null){
					if (elementos[i].childNodes[2].childNodes[0].nodeValue=="TRUE")
						selecionado = option.value;
				}
					
					
				//option.value = elementos[i].childNodes[0].nodeValue;
				//option.text = elementos[i].childNodes[1].nodeValue;				
				
				combo.options.add(option);
			}
		}
	}
	combo.options[0].value = '0';
	combo.options[0].text = 'Selecione...';
	combo.value= selecionado;
}

function montaParametros(form,parametro) {	

	var vetElem = form.elements;
	var elem;
	var parametros = '';
	var checks = new Hashtable();
	if (parametro != undefined && parametro != '')
		parametros = parametro + '&';
	for(var i=0;i<vetElem.length;i++){
		elem = vetElem[i];
		if (elem.disabled && !AJAX_SEND_FIELDS_DISABLEDS)
			continue;
		if (((elem.type == 'radio' || elem.type == 'checkbox') && elem.checked) || 
			(elem.type == 'text') ||
			(elem.type == 'hidden') ||
			(elem.type == 'password') ||
			(elem.type.indexOf('select') != -1) ||
			(elem.type == 'textarea')) {
			if (elem.type == 'checkbox')
			{
				if (checks.containsKey(elem.name))
				{
					checks.put(elem.name, checks.get(elem.name) + elem.value + ',');							
				}
				else
				{
					checks.put(elem.name, elem.value + ',');	
				}				
				continue;
			}
			parametros += elem.name + '=' + escape(elem.value) + '&';			
		}
	}
	var keys = checks.keys();	
	for (var i=0;i<keys.length;i++)
	{
		parametros += keys[i] + '=' + checks.get(keys[i]).substring(0,checks.get(keys[i]).length-1) + '&';
	}
	alert(parametros.substring(0,parametros.length-1));
	return parametros.substring(0,parametros.length-1);
}

function getText(node){
	if (node == null)
		return "";
	else
		return node.nodeValue;
}

//function getText(node) {
//	
//    var text = "";
//	alert(node.childNodes.length);
//    for (var i = 0; i < node.childNodes.length; i++) {
//        if (node.childNodes[i].nodeType == 3) {
//            text += node.childNodes[i].nodeValue;
//			alert(node.childNodes[i].text);
//        }
//    }
//    
//    return text;
//}

//function getText(node){
//	alert(node);
//	if (node==null)
//		return "";	
//	else{
//		alert(node.childNodes[0]);
//		return node.childNodes[0].nodeValue;
//	}
//		
//}


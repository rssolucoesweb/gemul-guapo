// JavaScript Document
function carregaAutoria()
{
	ExecAjax('cmbAutoria','Autoria_act.asp','');
}

function carregaEditora()
{
	ExecAjax('cmbEditora','Editora_act.asp','');	
}

function carregaCDU()
{
	var intCDU = document.getElementById('txtCodCDU').value;
	
	if (intCDU == '')
	{
		alert('O Código da CDU deve ser informado, Verifique!');
		return;
	}
	
	//Consulta Escola
	var funcCDU = function(xml)
	{
		if (xml.responseText == '')
		{
			alert('CDU não existe. Verifique!');
			return;
		}
		
		var cmbCDU = document.getElementById('cmbCDU');
		preencheCombo(xml.responseXML, cmbCDU);
		//document.frm.cmbCDU.value = intCodEscola;
	}
	ExecAjax(funcCDU,'Cdu_act.asp?CodCDU=' + intCDU,'');	
	
}
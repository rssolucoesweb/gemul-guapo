	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.action="sca_justificativa_faltas.asp";
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}	

	function abreConsultaImagem(caminho){
		
		var frm = document.getElementById("frm");
		
		window.open(caminho,"abreConsulta","top=5,left=5,height=710,width=919,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao == "E") {
			var msn = 'ATENÇÃO: Confirma a exclusão da justificativa de falta?';
			if (confirm(msn)) {
				frm.action="sca_justificativa_faltas_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			} else {
				return false;
			}

		} else {
		if (frm.txtAnoLetivo.value == "") {
			alert("Ano letivo deve ser informado!");
			frm.txtAnoLetivo.focus();
			return false;
		}

		if (frm.cmbSemestre.value == "0") {
			alert("Semestre deve ser informado!");
			frm.txtAnoLetivo.focus();
			return false;
		}

		if (frm.cmbBimestre.value == "0") {
			alert("O bimestre deve ser informado!");
			frm.txtNomealuno.focus();
			return false;
		}

		if (frm.cmbTipoJustificativa.value == "0") {
			alert("Tipo de justificativa deve ser informada!");
			frm.cmbTipoJustificativa.focus();
			return false;
		}

		if (frm.cmbTurma.value == "0") {
			alert("Turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}

		if (frm.cmbAluno.value == "0") {
			alert("Aluno deve ser informado!");
			frm.cmbAluno.focus();
			return false;
		}
		if (frm.txtDataInicial.value == "") {
			alert("Data inicial deve ser informada!");
			frm.txtDataInicial.focus();
			return false;
		}
		if (frm.txtDataFinal.value == "") {
			alert("Data final deve ser informada!");
			frm.txtDataFinal.focus();
			return false;
		}

		if (frm.txtJustificativa.value == "") {
			alert("A justificativa deve ser informada!");
			frm.txtJustificativa.focus();
			return false;
		}
		
		$("#txtTexto").val($("#editor").cleanHtml());
	
		if (frm.txtTexto.value == "") {
			alert("A imagem deve ser informada!");
			return false;
		}

		var textoInicial = frm.txtTexto.value.substring(1,4);
		var tamanho = parseInt(frm.txtTexto.value.length);
		if (textoInicial != "img" && acao=="I"){
			alert("Imagem do documento invalida, devera ser enviado somente documento do tipo IMAGEM (JPG ou PNG)!");
			return false;
		}	

		if (tamanho >= 3116802){ 
			alert("Imagem do documento deve ter no máximo 2MB, diminua a imagem e tente enviar novamente!");
			return false;
		}
		
		if (acao=="I") var msn = 'ATENÇÃO: Confirma a inclusão, só serão aceitas imagens de justificativa da falta?';
		if (acao=="A") var msn = 'ATENÇÃO: Confirma a alteração, só serão aceitas imagens de justificativa da falta?';

		if (confirm(msn)) {
			frm.action="sca_justificativa_faltas_cod.asp?acao=" + acao;
			frm.submit();
			return true;
		} else {
			return false;
		}
		}
 	}

	function validaDataNaTela(objCampo){
		//verifica se uma deterimnada data é válida ou não
		
		var strData = objCampo.value;
		if (strData==""){
			return false;
		}
		var intDia = parseInt(strData.substring(0,2),10);
		var intMes = parseInt(strData.substring(3,5),10);
		var intAno = parseInt(strData.substring(6,10),10);
		
		if (intDia <= 31 && intMes <=12 && intAno >= 1000){
		  if (strData.substring(0,1)=='0' && strData.substring(1,2) != '0' || strData.substring(0,1)!='0'){
		    if (strData.substring(2,3)=="/"){
		      if (strData.substring(3,4)=='0' && strData.substring(4,5)!='0' || strData.substring(3,4)!='0'){
		        if (strData.substring(5,6)=="/"){
		          if (strData.substring(6,7)== '0' || strData.substring(6,7)=='' && strData.substring(7,8)!='0'){
		            window.alert('Ano inexistente!');
					objCampo.value="";
	                objCampo.focus();
		            return false;
		          } 
		          else {
		            if (intMes == 2){
		              if ((intDia > 0 ) && (intDia <= 29)){
		                 if (intDia == 29){
		                    if ((intAno % 4) == 0){
		                     reloadDtFinal();
							 return true;
		                    }
		                    else {
		                      window.alert('Este dia não existe, digite novamente!');
							  objCampo.value="";
							  objCampo.focus();
		                      return false;
		                    }
		                 }
		              } 
		              else {
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
		                objCampo.focus();
		                return false;
		              }
		            }
					
		            if ((intMes == 4)||(intMes == 6)||(intMes == 9)||(intMes ==11)){
		              if ((intDia > 0 ) && (intDia <= 30)){
		                reloadDtFinal();
							 return true;
		              }
		              else{
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
						objCampo.focus();
		                return false;
		              }
		            }
		            if ((intMes == 1)||(intMes == 3)||(intMes == 5)||(intMes ==7)||(intMes ==8)||(intMes == 10)||(intMes == 12)) {
		              if ((intDia > 0) && (intDia <= 31)) {
		                reloadDtFinal();
							 return true;
		              }
		              else{
		                window.alert('Este dia não existe, digite novamente!');
						objCampo.value="";
						objCampo.focus();
		                return false;
		              }
		            }
		          }
		        }
		        else{
		          window.alert('A data digitada não está no formato padrão(dd/mm/aaaa)!');
					objCampo.value="";
	                objCampo.focus();
		          return false;
		        }
		      }
		      else{
		        window.alert('Mês inexistente!');
					objCampo.value="";
	                objCampo.focus();
		        return false;
		      }
		    }
		    else{
		      window.alert('A data digitada não está no formato padrão(dd/mm/aaaa)!');
					objCampo.value="";
	                objCampo.focus();
		      return false;
		    }
		  }
		  else{
		    window.alert('Dia inexistente!');
			objCampo.value="";
			objCampo.focus();
		    return false;
		  }
		}
		else {
		  window.alert('O dia e/ou o mês digitado não está no formato padrão (dd/mm/aaaa)!');
		  objCampo.value="";
		  objCampo.focus();
		  return false;
		}
		reloadDtFinal();
		return true;
	}

	function reloadDtFinal(){
		frm.action = "sca_justificativa_faltas.asp";
		frm.submit();
	}

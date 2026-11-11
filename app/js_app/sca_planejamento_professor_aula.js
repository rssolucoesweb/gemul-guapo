$( document ).ready(function() {

    if ($("#txtCodPlanejamentoProfessor").val() != "") {
        carregaPlanejamentoProfessor("1");
        carregaPlanejamentoProfessor("2");
        carregaPlanejamentoProfessor("3");
        carregaPlanejamentoProfessor("4");
    }

    $(".salvar").hide();

    $( "#txtMetodologia" ).keyup(function() {
        $("#btnMetodologia").show();
		verificaSituacaoEdicao();
    });   

    $( "#btnMetodologia" ).click(function() {
        incluiItemPlanejamento(3, 0, removeCaracterEspecial($( "#txtMetodologia" ).val()),'N');
        $("#btnMetodologia").hide();
    });   
        
    $( "#txtAvaliacao" ).keyup(function() {
        $("#btnAvaliacao").show();
		verificaSituacaoEdicao();
    });  
    
    $( "#btnAvaliacao" ).click(function() {
        incluiItemPlanejamento(4, 0, removeCaracterEspecial($( "#txtAvaliacao" ).val()),'N');
        $("#btnAvaliacao").hide();
    });    
	
	  $( "#txtObservacaoSecretaria" ).keyup(function() {
        $("#btnObservacaoSecretaria").show();
		verificaSituacaoEdicao();
    });  

});

function removeCaracterEspecial(texto) {
    return texto.replace(/'/g, '´').replace(/>/g, '').replace(/</g, '').trim()
}

toastr.options = {
    "closeButton": true,
    "newestOnTop": false,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }

  function mostraBotaoSalvarConteudo(cod_item_planejamento_professor) {
        $("#btnItem-"+cod_item_planejamento_professor).show();
  }

  function carregaPlanejamento(codPlanejamento) {

    $('#divListaPlanejamento').html('carregando...');
    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: codPlanejamento,
            acao: 'carregaPlanejamento',
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {

        $("#divListaPlanejamento").html(data);
        verificaSituacaoEdicao();
 
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    }); 

}

function controleAbertura(codItemPai,codTipo) {
    if ($("#txtControleAbertura-" + codItemPai + "-" + codTipo).val()=="S") {
        $("#txtControleAbertura-" + codItemPai + "-" + codTipo).val("N")
    }else {
        $("#txtControleAbertura-" + codItemPai + "-" + codTipo).val("S")
    }
}

function carregaItensTipo(codItemPai,codTipo) {

    if ($("#txtControleAbertura-" + codItemPai + "-" + codTipo).val()=="N") {
        $('#div-' + codItemPai + '-' + codTipo).html('fechado');
        return;
    }

    $('#div-' + codItemPai + '-' + codTipo).html('carregando...');

    switch(parseInt(codTipo)) {
        case 1:
        case 2:
        case 3:
        case 4:
          strAcao = 'carregaItensTipo';
          break;
        default:
            strAcao = '';
      }    
//alert($("#bolAulaExtra").val())
    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: $("#txtCodPlanejamento").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtHiddenSemestre").val(),
            codPeriodo:$("#txtHiddenCodPeriodo").val(),
            codBimestre:$("#cmbBimestre").val(),
            codDisciplina:$("#txtHiddenCodDisciplina").val(),            
            codItemPai: $("#cmbUnidadeTematica").val(), 
            bolAulaExtra: $("#bolAulaExtra").val(),
            codTipo: codTipo,
            acao: strAcao,
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        $('#div-' + codItemPai + '-' + codTipo).html(data);
        verificaSituacaoEdicao();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });   
}


function verificaSituacaoEdicao() {
		
		if ($("#edicao").val()=="S"){
			$('#btnMetodologia').hide();
			$('#btnAvaliacao').hide();
			$(".textArea").attr("disabled", true);
			//$('.edicao').hide();
		}

}
function excluir() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            acao: "ExcluirPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {

        carregaPlanejamentoProfessor("1");
        carregaPlanejamentoProfessor("2");
        carregaPlanejamentoProfessor("3");
        carregaPlanejamentoProfessor("4");

        $("#txtCodPlanejamentoProfessor").val("");

        toastr.success("Planejamento excluido com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function validar() {

   

    if( $("#cmbValidado").val()=="S" && ($("#txtMetodologia" ).val().trim() ==="" || $("#txtAvaliacao" ).val().trim() ==="" ||  $("#div-2").html().search("Nenhum item incluído") > -1)) {
        toastr.error("Atenção! Não é possível validar pois os campos Objetos de conhecimento, Metodologia e/ou Avaliação não foram informados pelo(a) professor(a).");
        return false;
    }


    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacao: $("#txtObservacao").val(),
            validado: $("#cmbValidado").val(),
            acao: "ValidarPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {
        toastr.success("Planejamento validado com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function salvarObservacaoSecretaria() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacaoSecretaria: $("#txtObservacaoSecretaria").val(),
            acao: "salvarObservacaoSecretaria"

        }
    )
    .done(function() {
        toastr.success("Observação da Secretaria salva com sucesso!");
		$('#btnObservacaoSecretaria').hide();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function cancelar() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacao: $("#txtObservacao").val(),
            validado: $("#cmbValidado").val(),
            acao: "CancelarValidacaoPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {
        toastr.success("Validação do Planejamento foi cancelado com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}
function incluiItemPlanejamento(codTipo, codItemPlanejamento, descricao, itemSelecionado) {
	descricaoExistente = ""
	if ($("#edicao").val()!="S"){

		if (codTipo==3 || codTipo==4) {
            if (itemSelecionado==="S") {
			    descricaoExistente = preencheCampo(codTipo, descricao);
                if (descricaoExistente!=undefined) {
                    descricao = descricaoExistente;
                }
            } 
		}
		
		if (codTipo==1 || codTipo==2) {
			if ($("#btnMetodologia").is(":visible")) {
				alert("Você ainda não salvou a Metodologia digitada!");
			}
			if ($("#btnAvaliacao").is(":visible")) {
				alert("Você ainda não salvou a Avaliação digitada!");
			}
		}

		$.post( "sca_planejamento_professor_aula_cod.asp", 
			{ 
				cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
				cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
				cod_item_planejamento_geral: codItemPlanejamento,
				anoLetivo: $("#txtHiddenAnoLetivo").val(),
				semestre: $("#txtSemestre").val(),
				codProfessor: $("#txtCodProfessor").val(),
				numeroAula: $("#txtHiddenAula").val(),
				bolAulaExtra: $("#bolAulaExtra").val(),
				cod_periodo: $("#txtCodPeriodo").val(),
				codDisciplina: $("#txtCodDisciplina").val(), 
				codTurno: $("#txtCodTurno").val(),
				codTurma: $("#txtCodTurma").val(),
				descricao: descricao,            
				codTipo: codTipo,
				acao: "incluiItemPlanejamento",
                periodoValido: $("#periodoValido").val()

			}
		)
		.done(function( data ) {
			
			vetRetorno = data.split(",");

			if ($("#txtCodPlanejamentoProfessor").val() =="") {
				$("#txtCodPlanejamentoProfessor").val(vetRetorno[0]);
			}

			if (codTipo==1 || codTipo==2) {
				carregaPlanejamentoProfessor(codTipo);
			}

			toastr.success("Item incluído com sucesso!");
		})
		.fail(function() {
			toastr.error("Ocorreu um erro");
		});    
	}
}

function preencheCampo(codTipo, texto) {
    var descricao = ""
    var descItem = ""

    if (codTipo==3) {
        descItem = "Metodologia"
    }else {
        descItem = "Avaliacao"
    }

    descricao = $("#txt" + descItem).val();

    if (descricao !="") {
        descricao += ", "
    } 

    descricao += texto
    $("#txt" + descItem).val(descricao);
    return descricao;
}

function carregaPlanejamentoProfessor(codTipo) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            codTipo: codTipo,
            acao: "carregaPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        switch(parseInt(codTipo)) {
            case 1:
            case 2:
                $('#div-' + codTipo).html(data);
                break;
            case 3:
            case 4:
                if (codTipo==3) {
                    descItem = "Metodologia"
                }else {
                    descItem = "Avaliacao"
                }                
                $("#txt" + descItem).val(data);
              break;
            default:
                break;
        }
        
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function removeItemPlanejamentoProfessor(codItemPlanejamentoProfessor, codTipo) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_item_planejamento_professor: codItemPlanejamentoProfessor,
            acao: "removeItemPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        carregaPlanejamentoProfessor(codTipo);
        toastr.success("Item excluído com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function salvaComplemento(codItemPlanejamentoProfessor) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_item_planejamento_professor: codItemPlanejamentoProfessor,
            descricao: $("#txtItem-"+codItemPlanejamentoProfessor).val(),
            acao: "salvaComplemento",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        toastr.success("Complemento incluído com sucesso!");
        $("#btnItem-"+codItemPlanejamentoProfessor).hide();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function atualizaBimestreTela() {

    for (let i = 1; i < 4; i++) {
        if ($("#txtControleAbertura-" + $("#txtCodPlanejamento").val() + "-" + i).val()=="S") {
            carregaItensTipo($("#txtCodPlanejamento").val(),i);
        }
    }

}
$(window).on("load", function(){
   verificaSituacaoEdicao();
   	$('#btnObservacaoSecretaria').hide();
});
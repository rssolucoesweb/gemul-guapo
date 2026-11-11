$( document ).ready(function() {

    $("#btnIncluirItem").click(function() {
        adicionarItem();
    });

    $("#btnIncluirItemUnidadeTematica").click(function() {
        adicionarItem();
    });

    $("#btnIncluirReplicacao").click(function() {
        executaReplicacao();
    });

    carregaPlanejamento();

});

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

function carregaCamposModal(bolBimestre, codigoItemPai, codigoTipo, unidadeTematica) {

    if (bolBimestre) {
        $("#divBimestre").show()
    }else{
        $("#divBimestre").hide()
    }
	if (unidadeTematica=="S") {
		$("#txtHiddenAcao").val('novoItemUnidadeTematica') 
	}else{
		$("#txtHiddenCodigoItemPai").val(codigoItemPai) 
		$("#txtHiddenCodigoTipo").val(codigoTipo) 
		
		if (codigoTipo!==0) {

			if ($("#txtHiddenOrigem").val()=='1') {
				$("#txtHiddenAcao").val('novoItem') 
			}else {
				$("#txtHiddenAcao").val('novoItemEscola') 
			}

		}else {
			if ($("#txtHiddenOrigem").val()=='1') {
				$("#txtHiddenAcao").val('novoCurriculo') 
			} else {
				$("#txtHiddenAcao").val('novoCurriculoEscola') 
			}
		}
	}
    $("#txtDescricao").val('') 

}
function carregaReplicarModal(item, codigoItemPai, codigoTipo, anoLetivo) {

    $("#txtHidden_cod_item_planejamento_geral").val(codigoItemPai);
    $("#txtNovoItemDescricao").val(item);
    $("#txtHidden_ano_letivo_replicacao").val(anoLetivo);
    

}
function adicionarItem() {

    if ($("#cmbBimestre").is( ":visible" )){

        if ($("#cmbBimestre").val()==0) {
            alert("O Bimestre não foi informado!");
            document.getElementById("cmbBimestre").focus();
            return false
        }
    }

    if ($.trim($("#txtDescricao").val())=="") {
        alert("A descrição do item não foi informada!");
        document.getElementById("txtDescricao").focus();
        return false        
    }

    $.post( "sca_curriculo_referencia_cod.asp", 
        { 
            codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
            codigoPlanejamentoEscola: $("#txtHiddenCodigoPlanejamentoEscola").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtHiddenSemestre").val(),
            codPeriodo:$("#txtHiddenCodPeriodo").val(),
            codBimestre:$("#cmbBimestre").val(),
            codDisciplina:$("#txtHiddenCodDisciplina").val(),
            codigoItemPai: $("#txtHiddenCodigoItemPai").val(), 
            codigoTipo: $("#txtHiddenCodigoTipo").val(), 
            descricao: $("#txtDescricao").val(),
            acao: $("#txtHiddenAcao").val()
        }
    )
    .done(function( data ) {

        $('#modalNovoItem').modal('hide');
        
        if ($("#txtHiddenAcao").val()=="novoCurriculo") {

            if ($("#txtHiddenCodigoPlanejamento").val()=="0") {
                $("#txtHiddenCodigoPlanejamento").val(data)
            }
            
            carregaPlanejamento();

        }
		else if ($("#txtHiddenAcao").val()=="novoItemUnidadeTematica") {

            if ($("#txtHiddenCodigoPlanejamento").val()=="0") {
                $("#txtHiddenCodigoPlanejamento").val(data)
            }
            
            carregaPlanejamento();

        }
        else if ($("#txtHiddenAcao").val()=="novoCurriculoEscola") {           
            if ($("#txtHiddenCodigoPlanejamentoEscola").val()=="0") {
                $("#txtHiddenCodigoPlanejamentoEscola").val(data)
            }
            
            carregaPlanejamento();            
        }
        else {

            carregaItensTipo($("#txtHiddenCodigoItemPai").val(), $("#txtHiddenCodigoTipo").val());
            
            if ($("#txtHiddenCodigoPlanejamentoEscola").val()=="0") {
                $("#txtHiddenCodigoPlanejamentoEscola").val(data)
            }            

        }
        toastr.success("Incluído com sucesso!");

    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    }); 

}

function executaReplicacao() {

	if ($("#cmbEmpresa").val()!="0")
		{
			if (!confirm("Atenção! O item será replicado para a unidade selecionada.\nDeseja continuar?")) {
        			return;
			}
	}else
		{
			if (!confirm("Atenção! O item será repliado para todas as unidades do município.\nDeseja continuar?")) {
        			return;
			}

		}

	$("#btnIncluirReplicacao").text('Aguarde replicação em andamento...') 
	$("#btnIncluirReplicacao").prop('disabled', true);

    $.post( "sca_curriculo_referencia_replicacao_cod.asp", 
        { 
            cod_item_planejamento_geral: $("#txtHidden_cod_item_planejamento_geral").val(),
	    cod_empresa: $("#cmbEmpresa").val(),
	    ano_letivo: $("#txtHidden_ano_letivo_replicacao").val()

        }
    )
    .done(function( data ) {
	$("#btnIncluirReplicacao").text('Replicar');
	$("#btnIncluirReplicacao").prop('disabled', false);
        $('#modalReplicar').modal('hide');
        
        toastr.success("Replicação finalizada com sucesso!");

    })
    .fail(function() {
	$("#btnIncluirReplicacao").text('Replicar');
	$("#btnIncluirReplicacao").prop('disabled', false);
        $('#modalReplicar').modal('hide');

        toastr.error("Ocorreu um erro na replicação!");
    }); 

}

function controleAbertura(codigoItemPai,codigoTipo) {
    if ($("#txtControleAbertura-" + codigoItemPai + "-" + codigoTipo).val()=="S") {
        $("#txtControleAbertura-" + codigoItemPai + "-" + codigoTipo).val("N")
    }else {
        $("#txtControleAbertura-" + codigoItemPai + "-" + codigoTipo).val("S")
    }
}
function carregaItensTipo(codigoItemPai,codigoTipo) {

    if ($("#txtControleAbertura-" + codigoItemPai + "-" + codigoTipo).val()=="N") {
        $('#div-' + codigoItemPai + '-' + codigoTipo).html('fechado');
        return;
    }

    $('#div-' + codigoItemPai + '-' + codigoTipo).html('carregando...');

    switch(parseInt(codigoTipo)) {
        case 1:
        case 2:
        case 3:
        case 4:
          strAcao = 'carregaItensTipo';
          break;
        default:
            strAcao = '';
      }    

    $.post( "sca_curriculo_referencia_cod.asp", 
        { 
            codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtHiddenSemestre").val(),
            codPeriodo:$("#txtHiddenCodPeriodo").val(),
            codBimestre:$("#cmbBimestre").val(),
            codDisciplina:$("#txtHiddenCodDisciplina").val(),            
            codigoItemPai: codigoItemPai, 
            codigoTipo: codigoTipo,
            acao: strAcao
        }
    )
    .done(function( data ) {
        $('#div-' + codigoItemPai + '-' + codigoTipo).html(data);
        verificaSituacaoEdicao();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });   
}

function carregaPlanejamento() {

    $('#divListaPlanejamento').html('carregando...');
    $.post( "sca_curriculo_referencia_cod.asp", 
        { 
            codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
            acao: 'carregaPlanejamento'
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

function removeItemPlanejamento(codigoItem) {

    if (!confirm("Atenção! Ao excluir este item você excluirá também as 'Habilidades' e 'Objetivos de conhecimento / Conteúdos' que estão relacionados a ele.\nDeseja continuar?")) {
        return;
    }

    $.post( "sca_curriculo_referencia_cod.asp", 
        { 
            codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
            codigoItem: codigoItem,
            acao: 'excluiItemPlanejamento'
        }
    )
    .done(function( data ) {

        $("#divPlanejamento"+codigoItem).hide();
        if (data == "0"){
            $("#txtHiddenCodigoPlanejamento").val(0)
        }
        toastr.success("Excluído com sucesso!");

    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });   

}

function removeItem(codigoItem) {

    if (!confirm("O item será excluído. Deseja continuar?")) {
        return;
    }    

    $.post( "sca_curriculo_referencia_cod.asp", 
        { 
            codigoItem: codigoItem,
            acao: 'excluiItem'
        }
    )
    .done(function( data ) {

        $("#item-"+codigoItem).hide();

        toastr.success("Excluído com sucesso!");

    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    }); 
}

function liberarProfessor(){
    if ($("#txtHiddenCodigoPlanejamento").val()!="0") {

        if (!confirm("Deseja liberar o planejamento para professor?")) {
            return;
        }

        $.post( "sca_curriculo_referencia_cod.asp", 
            { 
                codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
	        codigoPlanejamentoEscola: $("#txtHiddenCodigoPlanejamentoEscola").val(),
		anoLetivo: $("#txtHiddenAnoLetivo").val(),
	        Semestre: $("#txtHiddenSemestre").val(),
            	codPeriodo:$("#txtHiddenCodPeriodo").val(),
            	codBimestre:$("#cmbBimestre").val(),
            	codDisciplina:$("#txtHiddenCodDisciplina").val(),            
                acao: 'enviarAutorizacaoPlanejamentoEscola'
            }
        )
        .done(function( data ) {

            $('.edicao').hide();

            toastr.success("Enviado com sucesso!");
            $("#txtHiddenCodigoSituacaoPlanejamento").val("7");
            verificaSituacaoAutorizacao()

        })
        .fail(function() {
            toastr.error("Ocorreu um erro");
        });        

    }else {
        toastr.warning('Nenhum Planejamento iniciado!')
    }
}

function liberar(){
    if ($("#txtHiddenCodigoPlanejamento").val()!="0") {

        if (!confirm("Deseja liberar o planejamento para as Unidades Escolares?")) {
            return;
        }

        $.post( "sca_curriculo_referencia_cod.asp", 
            { 
                codigoPlanejamento: $("#txtHiddenCodigoPlanejamento").val(),
                acao: 'liberaPlanejamento'
            }
        )
        .done(function( data ) {

            $('.edicao').hide();

            toastr.success("Liberado com sucesso!");
            $("#txtHiddenCodigoSituacaoPlanejamento").val("3");
            verificaSituacaoEdicao()

        })
        .fail(function() {
            toastr.error("Ocorreu um erro");
        });        

    }else {
        toastr.warning('Nenhum Planejamento iniciado!')
    }
}

function verificaSituacaoAutorizacao() {

    if ($("#txtHiddenCodigoSituacaoPlanejamento").val()=="7" || $("#txtHiddenCodigoSituacaoPlanejamento").val()=="5") {
        $('.edicao').hide();
    }
           
}

function verificaSituacaoEdicao() {

    if ($("#txtHiddenCodigoSituacaoPlanejamento").val()=="3" || $("#txtHiddenCodigoSituacaoPlanejamento").val()=="7") {
        $('.edicao').hide();
    }
           
}
$( document ).ready(function() {

    if ($("#txtCodPlanejamentoProfessor").val() != "") {

        carregaPlanejamentoProfessor("2");
        listaConteudoExecutado($("#txtCodPlanejamentoProfessor").val());
        if ($("#periodoValido").val()==="S")
            listaTurmas();
    }  

});

function listaTurmas() {

    $('#divListaTurmas').html('carregando...');
    $.post( "sca_conteudo_ministrado_cod.asp", 
        { 
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtSemestre").val(),
            codPeriodo: $("#txtCodPeriodo").val(),
            codDisciplina: $("#txtCodDisciplina").val(), 
            codTurma: $("#txtCodTurma").val(), 
            txtCodProfessor: $("#txtCodProfessor").val(),
            aula: $("#txtHiddenAula").val(),
            bolAulaExtra: $("#bolAulaExtra").val(),
            acao: 'listarTurmasDisciplinaProfessor',
            periodoValido: $("#periodoValido").val()
        }      
    )
    .done(function( data ) {

        $("#divListaTurmas").html(data);
        //verificaSituacaoEdicao();
 
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });     

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

//   function mostraBotaoSalvarConteudo(cod_item_planejamento_professor) {
//         $("#btnItem-"+cod_item_planejamento_professor).show();
//   }

  function carregaPlanejamento(codPlanejamento) {

    $('#divListaPlanejamento').html('carregando...');
    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: codPlanejamento,
            apenasConteudo: 'S',
            acao: 'carregaPlanejamento',
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {

        $("#divListaPlanejamento").html(data);
        //verificaSituacaoEdicao();
 
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

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: $("#txtCodPlanejamento").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtHiddenSemestre").val(),
            codPeriodo:$("#txtHiddenCodPeriodo").val(),
            codBimestre:$("#cmbBimestre").val(),
            codDisciplina:$("#txtHiddenCodDisciplina").val(),            
            codItemPai: $("#cmbUnidadeTematica").val(), 
            codTipo: codTipo,
            acao: strAcao,
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        $('#div-' + codItemPai + '-' + codTipo).html(data);
        //verificaSituacaoEdicao();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });   
}


// function verificaSituacaoEdicao() {
		
// 		if ($("#edicao").val()=="S"){
// 			$('#btnMetodologia').hide();
// 			$('#btnAvaliacao').hide();
// 			$(".textArea").attr("disabled", true);
// 			//$('.edicao').hide();
// 		}

// }

// function excluir() {

//     $.post( "sca_planejamento_professor_aula_cod.asp", 
//         { 
//             cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
//             cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
//             anoLetivo: $("#txtHiddenAnoLetivo").val(),
//             semestre: $("#txtSemestre").val(),
//             codProfessor: $("#txtCodProfessor").val(),
//             numeroAula: $("#txtHiddenAula").val(),
//             acao: "ExcluirPlanejamentoProfessor"
//         }
//     )
//     .done(function() {

//         carregaPlanejamentoProfessor("1");
//         carregaPlanejamentoProfessor("2");
//         carregaPlanejamentoProfessor("3");
//         carregaPlanejamentoProfessor("4");

//         $("#txtCodPlanejamentoProfessor").val("");

//         toastr.success("Planejamento excluido com sucesso!");
//     })
//     .fail(function() {
//         toastr.error("Ocorreu um erro");
//     });    

// }

// function validar() {

//     $.post( "sca_planejamento_professor_aula_cod.asp", 
//         { 
//             cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
//             cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
//             anoLetivo: $("#txtHiddenAnoLetivo").val(),
//             semestre: $("#txtSemestre").val(),
//             codProfessor: $("#txtCodProfessor").val(),
//             numeroAula: $("#txtHiddenAula").val(),
//             observacao: $("#txtObservacao").val(),
//             validado: $("#cmbValidado").val(),
//             acao: "ValidarPlanejamentoProfessor"
//         }
//     )
//     .done(function() {
//         toastr.success("Planejamento validado com sucesso!");
//     })
//     .fail(function() {
//         toastr.error("Ocorreu um erro");
//     });    

// }

function incluiItemPlanejamento(codTipo, codItemPlanejamento, descricao) {
	
	executaConteudo("", codItemPlanejamento)
    
}

// function preencheCampo(codTipo, texto) {
//     var descricao = ""
//     var descItem = ""

//     if (codTipo==3) {
//         descItem = "Metodologia"
//     }else {
//         descItem = "Avaliacao"
//     }

//     descricao = $("#txt" + descItem).val();

//     if (descricao !="") {
//         descricao += ", "
//     } 

//     descricao += texto
//     $("#txt" + descItem).val(descricao);
//     return descricao;
// }

function carregaPlanejamentoProfessor(codTipo) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            codTipo: codTipo,
            paginaOrigem: 'cm', //conteudo ministrado
            acao: "carregaPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        switch(parseInt(codTipo)) {
            //case 1:
            case 2:
                $('#div-' + codTipo).html(data);
                break;
            // case 3:
            // case 4:
            //     if (codTipo==3) {
            //         descItem = "Metodologia"
            //     }else {
            //         descItem = "Avaliacao"
            //     }                
            //     $("#txt" + descItem).val(data);
            //   break;
            default:
                break;
        }
        
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

// function removeItemPlanejamentoProfessor(codItemPlanejamentoProfessor, codTipo) {

//     $.post( "sca_planejamento_professor_aula_cod.asp", 
//         { 
//             cod_item_planejamento_professor: codItemPlanejamentoProfessor,
//             acao: "removeItemPlanejamentoProfessor"
//         }
//     )
//     .done(function( data ) {
//         carregaPlanejamentoProfessor(codTipo);
//         toastr.success("Item excluído com sucesso!");
//     })
//     .fail(function() {
//         toastr.error("Ocorreu um erro");
//     });      

// }

// function salvaComplemento(codItemPlanejamentoProfessor) {

//     $.post( "sca_planejamento_professor_aula_cod.asp", 
//         { 
//             cod_item_planejamento_professor: codItemPlanejamentoProfessor,
//             descricao: $("#txtItem-"+codItemPlanejamentoProfessor).val(),
//             acao: "salvaComplemento"
//         }
//     )
//     .done(function( data ) {
//         toastr.success("Complemento incluído com sucesso!");
//         $("#btnItem-"+codItemPlanejamentoProfessor).hide();
//     })
//     .fail(function() {
//         toastr.error("Ocorreu um erro");
//     });      

// }

function atualizaBimestreTela() {

    for (let i = 1; i < 4; i++) {
        if ($("#txtControleAbertura-" + $("#txtCodPlanejamento").val() + "-" + i).val()=="S") {
            carregaItensTipo($("#txtCodPlanejamento").val(),i);
        }
    }

}

// $(window).on("load", function(){
//    verificaSituacaoEdicao();
// });


function executaConteudo(codItemPlanejamentoProfessor, codItemPlanejamentoGeral) {

    if ($("#txtDataAula").val().trim()==="") {
        toastr.warning("Data da aula vazia! Verifique");
        return
    }

    $.post( "sca_conteudo_ministrado_cod.asp", 
        { 
	    dataAula: $("#txtDataAula").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            cod_item_planejamento_professor: codItemPlanejamentoProfessor,
            cod_item_planejamento_geral: codItemPlanejamentoGeral,
            acao: "executaConteudo",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        toastr.success("Conteúdo executado com sucesso!");
        listaConteudoExecutado($("#txtCodPlanejamentoProfessor").val());
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function removeConteudoExecutado(codConteudoMinistradoProfessor) {

    $.post( "sca_conteudo_ministrado_cod.asp", 
        { 
            cod_conteudo_ministrado_professor: codConteudoMinistradoProfessor,
            acao: "removeConteudo",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        toastr.success("Conteúdo removido com sucesso!");
        listaConteudoExecutado($("#txtCodPlanejamentoProfessor").val());
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function listaConteudoExecutado(codPlanejamentoProfessor) {
    $("#divListaConteudoMinistrado").html("");

    $.get( "sca_conteudo_ministrado_cod.asp", 
        { 
            cod_planejamento_professor: codPlanejamentoProfessor,
            acao: "listaConteudoExecutado",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        $("#divListaConteudoMinistrado").html(data);
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });  
}

function salvaConteudoComplementar(codPlanejamentoProfessor) {

    $("#btnSalvarConteudoComplementar").attr("disabled",true);
    $("#btnSalvarConteudoComplementar").html("Aguarde... Salvando o Conteúdo Complementar");

    $.post( "sca_conteudo_ministrado_cod.asp", 
        { 
            cod_planejamento_professor: codPlanejamentoProfessor,
            conteudoComplementar: $("#txtConteudoComplementar").val(),
            acao: "salvaConteudoComplementar",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        toastr.success("Conteúdo Complementar incluído com sucesso!");
        $("#btnSalvarConteudoComplementar").html("Salvar Conteúdo Complementar");        
        $("#btnSalvarConteudoComplementar").attr("disabled",false);
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
        $("#btnSalvarConteudoComplementar").html("Salvar Conteúdo Complementar");                
        $("#btnSalvarConteudoComplementar").attr("disabled",false);
    });     

}

function replicar() {

    $("#btnReplicar").attr("disabled",true);
    $("#btnReplicar").html("Aguarde... Replicando Conteúdos Ministrados");

    strPlanejamentoOrigem = $("#txtCodPlanejamentoProfessor").val()
    strPlanejamentoDestino = ""

    $("input:checked").each(function(){
        if (strPlanejamentoDestino !== "") {
            strPlanejamentoDestino += ","
        }
        strPlanejamentoDestino += $(this).attr("codPlanejamentoProfTurma")
        console.log($(this).attr("codPlanejamentoProfTurma"));
    });    

    if (strPlanejamentoDestino !=="") {
        $.post( "sca_conteudo_ministrado_cod.asp", 
            { 
                strPlanejamentoOrigem: strPlanejamentoOrigem,
                strPlanejamentoDestino: strPlanejamentoDestino,
                acao: "replicar",
                periodoValido: $("#periodoValido").val()

            }
        )
        .done(function( data ) {

            toastr.success("Conteúdo Ministrado replicado com sucesso!");

            $("#btnReplicar").attr("disabled",false);
            $("#btnReplicar").html("Replicar");            

            listaTurmas();
        })
        .fail(function() {
            toastr.error("Ocorreu um erro");
            $("#btnReplicar").attr("disabled",false);
            $("#btnReplicar").html("Replicar");               

            listaTurmas();
        });  
    }else {
        toastr.warning("Nenhuma turma selecionada!");
        $("#btnReplicar").attr("disabled",false);
        $("#btnReplicar").html("Replicar");              
    }

}
const PAGE_NAME = 'Stock_VW';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';
const FILTER_SEL = '#' + PAGE_NAME + '_filter';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            document.title = config.Title;
            initCatalog(config);

            maskITENombre('#ITE_NombreFilter', {});
        }
    });
});

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true,
        showExport: true, dialogWidth: 800,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=Stock',
        deleteRequest: AJAX + '/PageInfo/DeletePageEntity?pageName=Stock',
        sorting: [[config.ColIdxs.ST_Fecha, 'desc']],
        validate: validateEntity,
        newEntityCallBack: newEntity,
        saveEntityCallBack: saveEntity,
        initCompleteCallBack: initComplete,
        appendNextPrevButtons: true
    });
}

function validateEntity(tips) {
    var config = $(TABLE_SEL).Catalog('getCatalogOptions').pageConfig;

    var valid = true;
    valid = valid && validateDialog(config, tips);

    if ($.trim($('#ITE_Nombre').val()).length != 13 || $('#ITE_Nombre').hasClass('invalid')) {
        tips.text('La Orden de Trabajo no es valida').addClass('ui-state-highlight');
        addErrorClass($('#ITE_Nombre')).focus();
        return false;
    }

    if(!$('#PN_Id').val()) {
        tips.text('El Numero de Plano no es valido').addClass('ui-state-highlight');
        addErrorClass($('#PN_Numero'));
        return false;
    }

    return valid;
}

function newEntity(oTable, options) {
    $(TABLE_SEL).Catalog('newEntity', oTable, options);
    $('#ST_Tipo').selectmenu('setValue', 'Entrada');
}

function saveEntity(oTable, options) {
    var entity = getObject(DIALOG_SEL);
    if (entity.ST_Tipo == 'Entrada') {
        $(TABLE_SEL).Catalog('saveEntity', oTable, options, entity);
    } else {
        validateExistencia(oTable, options, entity);
    }
}

function validateExistencia(oTable, options, entity) {
    $.when(getExistencia()).done(function (json) {
        var existencia = 0;
        if(json && json.aaData && json.aaData.length > 0) {
            existencia = parseFloat(json.aaData[0].Cantidad);
        }

        if (existencia < entity.ST_Cantidad) {
            var tips = $(DIALOG_SEL + ' p.validateTips');
            tips.text('No hay piezas suficientes en existencia para registrar esta Salida.').addClass('ui-state-highlight');
            addErrorClass($('#ST_Cantidad'));
        } else {
            $(TABLE_SEL).Catalog('saveEntity', oTable, options, entity);
        }
    });
}

function initComplete() {
    maskITENombre('#ITE_Nombre', {});
    attachHandlres();
}

function attachHandlres() {
    $('#PN_Numero').on('blur change', validatePlano);
    $('#ITE_Nombre').on('blur change', validateOrden);
    $('#ST_Tipo').selectmenu({ change: validateOrden });
}

function validatePlano() {
    if (!$.trim($('#PN_Numero').val())) return;

    var tips = $(DIALOG_SEL + ' p.validateTips');
    removeErrorClass($('#PN_Numero'));
    tips.text('').removeClass('ui-state-highlight');

    $.when(getPlano($('#PN_Numero').val())).done(function (json) {
        $('#PN_Id').val('');
        if (json && json.aaData && json.aaData.length > 0) {
            $('#PN_Id').val(json.aaData[0].PN_Id);
        } else {            
            tips.text('El Numero de Plano no existe').addClass('ui-state-highlight');
            addErrorClass($('#PN_Numero'));
        }
    });
}

function validateOrden() {
    var tips = $(DIALOG_SEL + ' p.validateTips');
    removeErrorClass($('#ITE_Nombre'));
    tips.text('').removeClass('ui-state-highlight');
    $('#ITE_Nombre').removeClass('invalid');

    if (!$.trim($('#ITE_Nombre').val())) return;
    if ($.trim($('#ITE_Nombre').val()).length != 13) {
        tips.text('La Orden de Trabajo no es valida').addClass('ui-state-highlight');
        addErrorClass($('#ITE_Nombre'));
        return;
    }

    $.when(getOrden($('#ITE_Nombre').val()), getStockOrden()).done(function (json, json2) {
        var ordenes = $.isArray(json) ? json[0] : json;
        var stockOrdenes = $.isArray(json2) ? json2[0] : json2;

        $('#Numero').val('');
        if (ordenes && ordenes.aaData && ordenes.aaData.length > 0) {
            $('#Numero').val(ordenes.aaData[0].Numero);
        } else {
            tips.text('La Orden de Trabajo no es valida').addClass('ui-state-highlight');
            addErrorClass($('#ITE_Nombre'));
            $('#ITE_Nombre').addClass('invalid');
        }

        if (stockOrdenes && stockOrdenes.aaData && stockOrdenes.aaData.length > 0) {
            tips.text('Ya existe una ' + $('#ST_Tipo').val() + ' para esta Orden de Trabajo.').addClass('ui-state-highlight');
            addErrorClass($('#ITE_Nombre'));
            $('#ITE_Nombre').addClass('invalid');
        }
    });
}

function getOrden(orden) {
    var entity = { ITE_Nombre: orden };

    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=ValidateOrden&entity=' + $.toJSON(entity), cache: false
    });
}

function getStockOrden() {
    var entity = { ITE_Nombre: $('#ITE_Nombre').val(), ST_Tipo: $('#ST_Tipo').val() };
    if ($('#ST_ID').val()) {
        entity.ST_ID = 'NOT_' + $('#ST_ID').val();
    }

    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=Stock&searchType=AND&entity=' + $.toJSON(entity), cache: false
    });
}

function getPlano(numero) {
    var entity = { PN_Numero: numero };

    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=Planos&searchType=AND&entity=' + $.toJSON(entity), cache: false
    });
}

function getExistencia() {
    var entity = { PN_Id: $('#PN_Id').val() };

    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=PiezasStock_vw&searchType=AND&entity=' + $.toJSON(entity), cache: false
    });
}
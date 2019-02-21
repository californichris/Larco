function createDefaultMenu() {
    $('#menu').addClass('ui-corner-all').menu({ position: { at: 'left bottom+2' }, my: 'left bottom' }, { icons: { submenu: 'ui-icon-triangle-1-s' } });
    $('#menu .ui-menu-item').addClass('ui-corner-all');
    $('#menu-container #menu ul.ui-menu').addClass('ui-corner-all');
    $('#menu a').css('text-decoration', 'none');
}

function createMenu() {
    if (typeof USER_MODULES == 'undefined' || USER_MODULES == null) {
        //log('No user modules define.');
        createDefaultMenu();
        return;
    }

    $('#menu').html('');

    var modules = $.evalJSON(USER_MODULES);
    var parentModules = jQuery.grep(modules, function (n, i) {
        return (n.ParentModule == '');
    });

    parentModules.sort(function (a, b) {
        var a1 = parseInt(a['ModuleOrder']), b1 = parseInt(b['ModuleOrder']);
        if (a1 == b1) return 0;
        return a1 > b1 ? 1 : -1;
    });

    for (var i = 0; i < parentModules.length; i++) {
        var module = parentModules[i];

        setURLAndTarget(module);

        $('#menu').append('<li moduleid="' + module.ModuleId + '"><a href="' + module.href + '" ' + module.target + '>' + module.ModuleName + '</a></li>');
        var childModules = jQuery.grep(modules, function (n, i) {
            return (n.ParentModule == module.ModuleId);
        });

        if (childModules.length > 0) {
            var parent = $('li[moduleid=' + module.ModuleId + ']');
            var ul = $('<ul></ul');
            parent.append(ul);

            childModules.sort(function (a, b) {
                var a1 = parseInt(a['ModuleOrder']), b1 = parseInt(b['ModuleOrder']);
                if (a1 == b1) return 0;
                return a1 > b1 ? 1 : -1;
            });

            for (var c = 0; c < childModules.length; c++) {
                if (childModules[c].ModuleName == 'Preview') continue;

                var childModule = childModules[c];
                setURLAndTarget(childModule);
                ul.append('<li><a href="' + childModule.href + '" ' + childModule.target + '>' + childModule.ModuleName + '</a></li>');
            }
        }
    }

    $('#menu').addClass('ui-corner-all').menu({ position: { at: 'left bottom+2' }, my: 'left bottom' }, { icons: { submenu: 'ui-icon-triangle-1-s' } });
    $('#menu .ui-menu-item').addClass('ui-corner-all');
    $('#menu-container #menu ul.ui-menu').addClass('ui-corner-all');
    $('#menu a').css('text-decoration', 'none');
}

function setURLAndTarget(module) {
    var href = '#';
    var target = "";
    if (module.URL.indexOf('http') != -1) {
        href = module.URL;
        target = ' target="_blank" ';
    } else if (module.URL != '') {
        href = APP_PATH + '/' + module.URL;
        if (module.URL.indexOf('pdf') != -1) {
            target = ' target="_blank" ';
        }
    }

    module.href = href;
    module.target = target;
}
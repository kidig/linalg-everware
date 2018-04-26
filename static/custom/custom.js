// --- //
define([
    'jquery',
    'base/js/namespace',
    'base/js/events'
], function ($, Jupyter, events) {
    var isGrade = function (cell) {
        if (cell.metadata.nbgrader === undefined) {
            return false;
        } else if (cell.metadata.nbgrader.grade === undefined) {
            return false;
        } else {
            return cell.metadata.nbgrader.grade;
        }
    };

    var gradeElem = '<div style="padding: 5px 5px 5px 0; color: #f04040; font-weight: bold;">С оценкой:</div>';

    events.on('notebook_loaded.Notebook', function () {
        var cells = Jupyter.notebook.get_cells();

        cells.forEach(function (cell) {
            if (isGrade(cell)) {
                console.log(cell);

                var $cellElem = $(cell.element);

                $($cellElem.find('.inner_cell')).prepend(gradeElem);
            }
        });
    });
});

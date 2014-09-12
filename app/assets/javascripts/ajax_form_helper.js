
var g_currentAjaxForm = null;

function showAjaxForm(formContainerId, formHtml, idsToHide) {

  if (g_currentAjaxForm != null) closeAjaxForm();

  if (isDefinedAndNonNull(idsToHide)) {
    for (var i = 0; i < idsToHide.length; i++)
      $('#' + idsToHide[i]).hide();
  }

  $('#' + formContainerId).html(formHtml).show();

  g_currentAjaxForm = {
    formContainerId: formContainerId,
    idsToHide: idsToHide
  }
}

function closeAjaxForm() {
  $('#' + g_currentAjaxForm.formContainerId).empty().hide();
  if (isDefinedAndNonNull(g_currentAjaxForm.idsToHide)) {
    for (var i = 0; i < g_currentAjaxForm.idsToHide.length; i++)
      $('#' + g_currentAjaxForm.idsToHide[i]).show();
  }
  g_currentAjaxForm = null;
}

var g_currentAjaxModalForm = null;
function showAjaxModalForm(modalId, formHtml) {

  if (g_currentAjaxModalForm != null) closeAjaxModalForm();

  var modalOptions = { backdrop:'static', show: false };

  if (isDefinedAndNonNull(formHtml)) {
    $('#' + modalId + ' div[id="modal-form"]').empty().html(formHtml);
  }

  // hook up the submit button
  $('#modal-form-dialog-submit').click(
    function() {
      $('#' + modalId + ' form').submit();
      $('#' + g_currentAjaxModalForm.modalId).modal('hide');
    }
  );
  $('#' + modalId).modal(modalOptions);
  $('#' + modalId).modal('show');

  g_currentAjaxModalForm = {
    modalId: modalId
  }

}

function closeAjaxModalForm() {
  $('#' + g_currentAjaxModalForm.modalId).modal('hide');
  $('#' + g_currentAjaxModalForm.modalId + ' div[id="modal-form"]').empty();
  g_currentAjaxModalForm = null;
}

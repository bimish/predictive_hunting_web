
var g_currentAjaxForm = null;

function showAjaxForm(formContainerId, formHtml, idsToHide) {

  if (g_currentAjaxForm != null) closeAjaxForm();

  if (idsToHide != null) {
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
  if (g_currentAjaxForm.idsToHide != null) {
    for (var i = 0; i < g_currentAjaxForm.idsToHide.length; i++)
      $('#' + g_currentAjaxForm.idsToHide[i]).show();
  }
  g_currentAjaxForm = null;
}

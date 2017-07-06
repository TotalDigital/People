const remoteInputs = () => {
  function displayInput(e) {
    e.preventDefault();
    const remoteInput = $("." + $(this).data("inputsClass"));
    remoteInput.toggleClass("hidden");
    remoteInput.find(".js-edit-field").focus();
  }

  function submitForm() {
    $(this).parents("form").submit();
  }

  $(document).on("click", ".edit-link", displayInput);
  $(document).on("blur", ".js-edit-field", submitForm);
};

export default remoteInputs;

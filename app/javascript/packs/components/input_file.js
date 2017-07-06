const inputFile = () => {
  const $elements = {
    inputFile: $(":file"),
  };

  function displayFileName(event, numFiles, label) {
    $(this).closest("form").addClass("visible");
    $(this).closest("label").find("span.text").text(label);
  }

  function triggerFileSelect() {
    var input = $(this),
      numFiles = input.get(0).files ? input.get(0).files.length : 1,
      label = input.val().replace(/\\/g, "/").replace(/.*\//, "");
    input.trigger("fileselect", [numFiles, label]);
  }

  $(document).on("change", ":file", triggerFileSelect);
  $elements.inputFile.on("fileselect", displayFileName);
};

export default inputFile;

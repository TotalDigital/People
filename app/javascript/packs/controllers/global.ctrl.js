import { controllers } from "frmr";
import remoteInputs from "packs/components/remote_inputs";
import inputFile from "packs/components/input_file";
import dateSelect from "packs/components/date_select";
import searchAutocomplete from "packs/components/search_autocomplete";

controllers.registerGlobalController(() => {
  const $elements = {
    multiSelect: $(".js-multiSelect"),
  };

  $elements.multiSelect.select2();
  remoteInputs();
  inputFile();
  dateSelect();
  searchAutocomplete();
});

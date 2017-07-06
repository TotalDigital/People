import { controllers } from "frmr";

controllers.registerController("profile", () => {
  const $elements = {
    autocompleteRelationTerm: $("#js-autocompleteRelationTerm"),
    relationshipTargetId: $("#relationship_target_id"),
  };

  $elements.autocompleteRelationTerm.blur(function(e) {
    if ($(this).val() == "") {
      $elements.relationshipTargetId.val("");
    }
  });

  console.log($elements);
});

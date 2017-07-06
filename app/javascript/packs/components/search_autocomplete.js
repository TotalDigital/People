import { debounce } from "packs/utils/function";

const searchAutocomplete = () => {
  let resultBoxId = -1;
  let userSlug = null;

  const UP_KEY = 40;
  const DOWN_KEY = 38;
  const ENTER_KEY = 13;
  const NAVIGATION_KEYS = [UP_KEY, DOWN_KEY, ENTER_KEY];
  const DEBOUNCE_DELAY = 250;

  const $elements = {
    searchAutocomplete: $("#search_autocomplete"),
    searchTerm: $("#search_term"),
    searchResults: $("#search-results"),
  };

  function navigate(diff) {
    resultBoxId += diff;
    const resultBoxes = $(".result_box");
    resultBoxes.removeClass("result_box_hover");

    if (resultBoxId >= resultBoxes.length || resultBoxId == -1) {
      resultBoxId = -1;
      userSlug = null;
    } else {
      const selectedBox = resultBoxes.eq(resultBoxId);
      selectedBox.addClass("result_box_hover");
      userSlug = selectedBox.data("user-slug");
    }
  }

  function handleInput(e) {
    const inputKey = e.keyCode;

    if (NAVIGATION_KEYS.indexOf(inputKey) > -1) {
      handleNavigationKeys(e);
    } else {
      const searchTerm = $(this).val();
      $elements.searchTerm.val(searchTerm);
      debouncedSearch(searchTerm);
    }
  }

  function handleNavigationKeys(e) {
    const inputKey = e.keyCode;
    if (inputKey == UP_KEY) {
      navigate(1);
    } else if (inputKey == DOWN_KEY) {
      navigate(-1);
    } else if (inputKey == ENTER_KEY) {
      if (userSlug != null) {
        e.preventDefault();
        window.location.replace("/p/" + userSlug);
      }
    }
  }

  function search(searchTerm) {
    if (searchTerm.length > 2) {
      searchRequest = $.ajax({
        type: "GET",
        url: "/p/autocomplete",
        data: {
          term: searchTerm,
          format: "html",
        },
        dataType: "text",
        success: function(html) {
          $elements.searchResults.html(html);
        },
      });
    } else {
      $elements.searchResults.empty();
    }
  }

  const debouncedSearch = debounce(search, DEBOUNCE_DELAY);

  function emptySearchResults(e) {
    const $clickTarget = $(e.relatedTarget);
    if ($elements.searchResults.find($clickTarget).length === 0) {
      $elements.searchResults.empty();
    }
  }

  $elements.searchAutocomplete.keyup(handleInput);
  $elements.searchAutocomplete.focusout(emptySearchResults);
};

export default searchAutocomplete;

const dateSelect = () => {
  let start_date = null;
  let end_date = null;

  const elements = {
    submitDates: ".js-submit-dates",
    submitNewProject: ".js-submit-project",
    submitNewJob: ".js-submit-job",
    currentCheckBox: "input[type=checkbox].js-current-end-date",
    editJobPencil: ".js-edit-job-dates",
    editProjectPencil: ".js-edit-projectparticipation-dates",
  };

  function formatDates() {
    var form = $(this).closest("form");
    var start_year = form.find(".js-start-year").val();
    var start_month = form.find(".js-start-month").val() - 1;
    start_date = new Date(start_year, start_month, 1);

    if (
      form.find("input[type='checkbox'].js-current-end-date").is(":checked") ==
      true
    ) {
      end_date = null;
    } else {
      var end_year = form.find(".js-end-year").val();
      var end_month = form.find(".js-end-month").val() - 1;
      end_date = new Date(end_year, end_month, 1);
    }
    form.find(".js-start-date").val(start_date);
    form.find(".js-end-date").val(end_date);
  }

  function ToggleDateInputs() {
    $(this).siblings(".update-dates").toggleClass("hidden");
    $(this).siblings(".display-dates").toggleClass("hidden");
    $(this).toggleClass("hidden");
  }

  function HideEnddateInputs() {
    $(this)
      .parents("span.end-date")
      .children(".end-dates")
      .toggleClass("hidden");
  }

  $(document).on("change", elements.currentCheckBox, HideEnddateInputs);
  $(document).on("click", elements.submitDates, formatDates);
  $(document).on("click", elements.submitNewProject, formatDates);
  $(document).on("click", elements.submitNewJob, formatDates);
  $(document).on("click", elements.editJobPencil, ToggleDateInputs);
  $(document).on("click", elements.editProjectPencil, ToggleDateInputs);
};

export default dateSelect;

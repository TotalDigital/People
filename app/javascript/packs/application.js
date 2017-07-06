/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Import various polyfilles
import "packs/utils/polyfills";

// Imports jquery and exposes it globally as $ and Jquery
import "expose-loader?$!expose-loader?jQuery!jquery";

// Needed for autocomplete-rails
import "jquery-ujs";
import "jquery-ui";
import "jquery-ui/ui/widgets/autocomplete";
import "./vendor/autocomplete-rails";

// Various dependencies
import "bootstrap";
import "select2";

// Imports and expose hopscotch globally
import "expose-loader?hopscotch!hopscotch";

// Imports Frmr to manage our apps front-end controllers
import { controllers } from "frmr";
import { requireAll } from "./utils/webpack";

// Load our entire "controllers" folder
requireAll(require.context("./controllers/", true, /\.js$/));

$(document).ready(() => {
  controllers.run(); // Run our controller system
});

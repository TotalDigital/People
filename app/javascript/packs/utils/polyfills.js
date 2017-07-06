import Promise from "promise-polyfill";
import "babel-polyfill";
if (!window.Promise) {
  window.Promise = Promise;
}
import "whatwg-fetch";

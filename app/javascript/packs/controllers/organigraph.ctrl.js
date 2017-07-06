import { controllers } from "frmr";
import PeopleOrganigraph from "people-organigraph";

controllers.registerController("organigraph", () => {
  const organigraphEndpoints = {
    graph: id => `/p/${id}/graph_json`,
    user: id => `/p/${id}/user_json`,
  };

  const organigraphLinks = {
    user: id => `/p/${id}`,
  };

  PeopleOrganigraph("#js-organigraph", {
    initialUserId: window.organigraphCurrentUser,
    endpoints: organigraphEndpoints,
    links: organigraphLinks,
  });
});

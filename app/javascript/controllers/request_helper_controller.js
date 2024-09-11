import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    // console.log("request-helper connected");
  }

  disconnect() {
    // console.log("request-helper disconnected");
  }

  async turboGet(url, callback) {
    // console.log("turboGet", url);

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    // https://github.com/rails/request.js#how-to-use
    const response = await get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });

    if (response.ok) {
      // console.log("OK");
      if (callback) {
        callback();
      } else {
        return 1; // truthy
      }
    } else {
      console.debug(response);
      return; // falsy
    }
  }
}

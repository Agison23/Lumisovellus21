var _ref;

export function loadStripedPolygonImagesToMap(
  mapRef,
  combinations,
  fillColors
) {
  _ref = mapRef;
  combinations.forEach((combination) => {
    var colors = combination.split(":");
    const firstColor = fillColors[colors[0]];
    const secondColor = fillColors[colors[1]];

    var background = firstColor;
    var stripes = secondColor !== undefined ? secondColor : background;

    console.log(combination + " " + background + " " + stripes);
    const svgString = `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 100 100"><defs><style>.cls-1,.cls-4{fill:none;}.cls-2{clip-path:url(#clip-path);}.cls-3{fill:${background};}.cls-4{stroke:${stripes};stroke-miterlimit:10;stroke-width:2.5px;}.cls-5{fill:url(#_9-1.5);}</style><clipPath id="clip-path"><polygon id="SVGID" class="cls-1" points="0 100 100 100 100 0 0 0 0 100"/></clipPath><pattern id="_9-1.5" data-name="9-1.5" width="100" height="100" patternTransform="translate(-138.07 -72.72)" patternUnits="userSpaceOnUse" viewBox="0 0 100 100"><rect class="cls-1" width="100" height="100"/><g class="cls-2"><rect class="cls-3" x="-6.89" y="-6.69" width="114.12" height="113.73"/><line class="cls-4" x1="53.03" y1="-53.03" x2="-53.03" y2="53.03"/><line class="cls-4" x1="63.03" y1="-43.03" x2="-43.03" y2="63.03"/><line class="cls-4" x1="73.03" y1="-33.03" x2="-33.03" y2="73.03"/><line class="cls-4" x1="83.03" y1="-23.03" x2="-23.03" y2="83.03"/><line class="cls-4" x1="93.03" y1="-13.03" x2="-13.03" y2="93.03"/><line class="cls-4" x1="103.03" y1="-3.03" x2="-3.03" y2="103.03"/><line class="cls-4" x1="113.03" y1="6.97" x2="6.97" y2="113.03"/><line class="cls-4" x1="123.03" y1="16.97" x2="16.97" y2="123.03"/><line class="cls-4" x1="133.03" y1="26.97" x2="26.97" y2="133.03"/><line class="cls-4" x1="143.03" y1="36.97" x2="36.97" y2="143.03"/><line class="cls-4" x1="153.03" y1="46.97" x2="46.97" y2="153.03"/></g></pattern></defs><title>Asset 3</title><g id="Layer_2" data-name="Layer 2"><g id="Layer_1-2" data-name="Layer 1"><rect class="cls-5" width="100" height="100"/></g></g></svg>`;
    svgString2Image(svgString, 100, 100, setImage, combination);
  });
}

function setImage(image, combination) {
  _ref.loadImage(image, function (err, image) {
    // Throw an error if something went wrong
    if (err) throw err;

    // Declare the image
    //THIS CAUSES: Error: An image with this name already exists. wont fix
    _ref.addImage(combination, image);
  });
}

//https://stackoverflow.com/questions/46814480/how-can-convert-a-base64-svg-image-to-base64-image-png
function svgString2Image(svgString, width, height, callback, combination) {
  // SVG data URL from SVG string
  var svgData =
    "data:image/svg+xml;base64," +
    btoa(unescape(encodeURIComponent(svgString)));
  // create canvas in memory(not in DOM)
  var canvas = document.createElement("canvas");
  // get canvas context for drawing on canvas
  var context = canvas.getContext("2d");
  // set canvas size
  canvas.width = width;
  canvas.height = height;
  // create image in memory(not in DOM)
  var image = new Image();
  // later when image loads run this
  image.onload = function () {
    // async (happens later)
    // clear canvas
    context.clearRect(0, 0, width, height);
    // draw image with SVG data to canvas
    context.drawImage(image, 0, 0, width, height);
    // snapshot canvas as png
    var pngData = canvas.toDataURL("image/png");
    // pass png data URL to callback
    callback(pngData, combination);
  }; // end async
  // start loading SVG data into in memory image
  image.src = svgData;
}

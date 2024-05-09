import maplibregl from "maplibre-gl";

export function createMarkersForMonitors(map, monitorData) {
  let markers = [];
  monitorData.forEach((monitor) => {
    if (monitor.temperature === "No Data" || monitor.snowDepth === "No Data") {
      return;
    }
    const currentMonitor = document.createElement("img");
    currentMonitor.className = "monitor";
    currentMonitor.src = "icons/fmd_bad.svg";
    currentMonitor.alt = "monitor_icon";
    currentMonitor.style.width = "40px";
    currentMonitor.style.height = "40px";
    
    let currentPopup;
    const popupFields = {
            className: "monitor-popup",
            offset: 20,
            closeOnClick: false,
            closeButton: false,
    };
    // set the orientation of popups so that they don't overlap.
    if (monitor.name.includes("Lehmäkero")) {
        currentPopup = new maplibregl.Popup({
            ...popupFields,
            anchor: "right",
    });
    } else if (monitor.name.includes("Pyhäkero") || monitor.name.includes("Metsä")) {
        currentPopup = new maplibregl.Popup({
            ...popupFields,
            anchor: "left",
    });
    } else {
        currentPopup = new maplibregl.Popup(popupFields);
    }

    currentPopup.setHTML(`
      <div style='text-align: center; font-family: Donau; letter-spacing: 2px; font-size: large'>
        <p>❄️ ${monitor.snowDepth} </p>
        <p>🌡️ ${monitor.temperature.split(" ")[0]} °C </p>
      </div>
    `);

    const currentMarker = new maplibregl.Marker(currentMonitor)
      .setLngLat([monitor.lng, monitor.lat])
      .setPopup(currentPopup)
      .addTo(map);
    markers.push(currentMarker);
  });

  return markers;
}

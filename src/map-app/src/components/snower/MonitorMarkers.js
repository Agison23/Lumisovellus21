import maplibregl from "maplibre-gl";

export function createMarkersForMonitors(map, monitorData) {
  let markers = [];
  monitorData.forEach((monitor) => {
    if (monitorData.temperature === '"No Data' || monitorData.snowDepth === 'No Data') {
      return;
    }
    
    const currentMonitor = document.createElement("img");
    currentMonitor.className = "monitor";
    currentMonitor.src = "icons/fmd_bad.svg";
    currentMonitor.alt = "monitor_icon";
    currentMonitor.style.width = "40px";
    currentMonitor.style.height = "40px";

    const currentPopup = new maplibregl.Popup({
      className: "monitor-popup",
      offset: 25,
      closeOnClick: true,
      closeButton: false,
    }).setHTML(`
      <div style='text-align: center; font-family: Donau; letter-spacing: 2px; font-size: large'>
        <p>❄️ ${monitor.snowDepth} </p>
        <p>🌡️ ${monitor.temperature} </p>
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

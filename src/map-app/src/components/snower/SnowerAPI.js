import { defaultBoundingBox } from "../map/PallasMap";

export const defaultMonitors = [
  {
    lat: 68.045527778,
    lng: 24.06225,
    name: "Aistin Level Pro #12648",
    temperature: "No Data",
    snowDepth: "No Data",
  },
  {
    lat: 68.079611111,
    lng: 24.070944444,
    name: "Aistin Level Pro #12649",
    temperature: "No Data",
    snowDepth: "No Data",
  },
  {
    name: "Pallas - huippu",
    lat: 68.059666819,
    lng: 24.03386725,
    temperature: "No Data",
    snowDepth: "No Data",
  },
  {
    name: "Pallas - metsä",
    lat: 68.046281479,
    lng: 24.05705337,
    temperature: "No Data",
    snowDepth: "No Data",
  },

];

function formatValue(value, unit) {
  const num = parseFloat(value);
  if (isNaN(num)) {
    return "Not available";
  }
  return `${num.toFixed(2)} ${unit}`;
}

function mergeArrays(arr1, arr2) {
  const merged = arr1.map(item1 => {
    const matchingItem = arr2.find(item2 => item2.name === item1.name);
    return matchingItem ? { ...item1, ...matchingItem } : item1;
  });

  // Add items from arr2 that are not present in arr1
  arr2.forEach(item2 => {
    const exists = merged.some(item => item.name === item2.name);
    if (!exists) {
      merged.push(item2);
    }
  });

  return merged;
}


const credentialURL = "https://app.snower.fi/api/login";
const monitorListURL = "https://app.snower.fi/api/monitors_list";
const monitorActiveStatusURL =
  "https://app.snower.fi/api/monitor_active_status";
const monitorLocationURL = "https://app.snower.fi/api/monitor_location";
const latestReadingURL = "https://app.snower.fi/api/last_reading";
export class SnowerAPI {
  constructor(props) {
    this.props = props;
    this.authKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkb21haW5fcm9sZXMiOnsicHVibGljIjpbImFwaXMtYWNjZXNzIl19LCJ1c2VyX2lkIjoicHVibGljX2FwaXNfdXNlciJ9.aOq9ZkzxokT3q0-zgpw95pFOhvdre9tgNMoiL4RkTVk";
    this.boundingBox = this.props.bounds || defaultBoundingBox;
    this.monitorList = [];
    this.monitorData = [];
  }

  async fetchAuthKey() {
    try {
      const response = await fetch(credentialURL, {
        method: "POST",
        headers: {
          "Content-Type": "text/plain",
          "domain-id": "public",
        },
        body: JSON.stringify({
          username: "publicapisuser",
          password: "TlLWIooyMf7aXB2",
        }),
      });

      if (!response.ok) {
        return;
      }
      const data = await response.json();
      if (data && data.authentication_key) {
        this.authKey = data.authentication_key;
      }
      return;
    } catch (error) {
      console.error("Error fetching monitor list info:", error);
    }
  }

  async fetchMonitorList() {
    try {
      const response = await fetch(monitorListURL, {
        method: "POST",
        headers: {
          "Content-Type": "text/plain",
          "authentication-key": this.authKey,
          "domain-id": "public",
        },
        body: JSON.stringify({
          area: "Pallas",
        }),
      });

      if (!response.ok) {
        this.monitorList = defaultMonitors.map((m) => m.name);
        return;
      }
      this.monitorList = await response.json();
    } catch (error) {
      console.error("Error fetching monitor list info:", error);
    }
  }

  async fetchMonitorActiveStatus() {
    try {
      const monitorStatusPromises = this.monitorList.map(async (monitor) => {
        try {
          const response = await fetch(monitorActiveStatusURL, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "authentication-key": this.authKey,
              "domain-id": "public",
            },
            body: JSON.stringify({ monitor, area: "Pallas" }),
          });

          if (!response.ok) {
            console.error("Error fetching monitor active status:", monitor);
            return null;
          }

          const data = await response.json();
          if (data && data.active_status === true) {
            return monitor;
          } else {
            return null;
          }
        } catch (error) {
          console.error("Error fetching monitor active status:", error.message);
          return null;
        }
      });

      this.monitorList = (await Promise.all(monitorStatusPromises)).filter(
        (monitor) => monitor !== null
      );
    } catch (error) {
      console.error("Error fetching monitor active status:", error);
    }
  }

  async fetchMonitorLocation() {
    try {
      const monitorLocationPromises = this.monitorList.map(async (monitor) => {
        try {
          const response = await fetch(monitorLocationURL, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "authentication-key": this.authKey,
              "domain-id": "public",
            },
            body: JSON.stringify({ monitor, area: "Pallas" }),
          });

          if (!response.ok) {
            console.error("Error fetching monitor location:", monitor);
            return null;
          }

          const data = await response.json();
          if (data && data.location && data.location.lat && data.location.lng) {
            const { lat, lng } = data.location;
            // Check if the location is within the bounding box
            const [minLng, minLat] = this.boundingBox[0];
            const [maxLng, maxLat] = this.boundingBox[1];

            if (
              lat >= minLat &&
              lat <= maxLat &&
              lng >= minLng &&
              lng <= maxLng
            ) {
              return {
                name: monitor,
                lat: lat,
                lng: lng,
              };
            } else {
              // Location is outside the bounding box, skip this monitor
              return null;
            }
          } else {
            return null;
          }
        } catch (error) {
          console.error("Error fetching monitor location:", error.message);
          return null;
        }
      });

      this.monitorList = (await Promise.all(monitorLocationPromises)).filter(
        (monitor) => monitor !== null
      );
    } catch (error) {
      console.error("Error fetching monitor location:", error);
    }
  }
  async fetchMonitorReading() {
    try {
      const promises = this.monitorList.map(async (monitor) => {
        try {
          const response = await fetch(latestReadingURL, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "authentication-key": this.authKey,
              "domain-id": "public",
            },
            body: JSON.stringify({ monitor: monitor.name, area: "Pallas" }),
          });

          if (!response.ok) {
            return {
              ...monitor,
            };
          }

          const data = await response.json();

          const formattedData = {
            temperature: formatValue(
              data?.probe_temperature?.value,
              data?.probe_temperature?.unit
            ),
            snowDepth: formatValue(
              data?.snow_depth?.value,
              data?.snow_depth?.unit
            ),
          };

          return {
            ...monitor,
            ...formattedData,
          };
        } catch (error) {
          console.error("Error processing monitor data:", error.message);
          return null;
        }
      });

      this.monitorData = await Promise.all(
        promises.filter((promise) => promise !== null)
      );
    } catch (error) {
      console.error("Error fetching monitor info:", error);
    }
  }

  getData() {
    if (!this.monitorData || !this.monitorData.length) {
      return defaultMonitors;
    }
    return mergeArrays(defaultMonitors, this.monitorData);
  }

  // This function is to fetch information from the local storage so that don't need to call API every time this refresh
  async fetchDataAndStore() {
    const localStorageKey = "monitorData";
    const storedData = localStorage.getItem(localStorageKey);

    if (storedData) {
      this.monitorData = JSON.parse(storedData);
    } else {
      await this.fetchAuthKey();
      await this.fetchMonitorList();
      await this.fetchMonitorActiveStatus();
      await this.fetchMonitorLocation();
      await this.fetchMonitorReading();
      localStorage.setItem(localStorageKey, JSON.stringify(this.monitorData));
    }
  }
}
// Example usage, this is used in PallasMap.js
// useEffect(() => {
//   const snowerService = new SnowerAPI();

//   async function fetchData() {
//     await snowerService.fetchDataAndStore();
//     const data = snowerService.getData();
//     setMonitorData(data);
//   }

//   fetchData();
// }, []);

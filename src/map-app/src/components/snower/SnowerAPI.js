export const monitors = [
  {
    name: "Pallas - metsä",
    lat: 68.046281479,
    lng: 24.05705337,
  },
  {
    name: "Pallas - huippu",
    lat: 68.059666819,
    lng: 24.03386725,
  },
];

function formatValue(value, unit) {
  const num = parseFloat(value);
  if (isNaN(num)) {
    return "Not available";
  }
  return `${num.toFixed(2)} ${unit}`;
}

const urlInfo = "https://app.snower.fi/api/last_reading";

export class SnowerAPI {
  constructor() {
    this.monitorData = [];
  }

  async fetchDataFromAPI() {
    try {
      const promises = monitors.map(async (monitor, index) => {
        const response = await fetch(urlInfo, {
          method: "POST",
          headers: {
            "Content-Type": "text/plain",
            "authentication-key":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkb21haW5fcm9sZXMiOnsicHVibGljIjpbImFwaXMtYWNjZXNzIl19LCJ1c2VyX2lkIjoicHVibGljX2FwaXNfdXNlciJ9.aOq9ZkzxokT3q0-zgpw95pFOhvdre9tgNMoiL4RkTVk",
            "domain-id": "public",
          },
          body: JSON.stringify({ monitor: monitor.name }),
        });

        if (!response.ok) {
          return monitor[index];
        }

        const data = await response.json();
        const temperature_unit =
          data["probe_temperature"]["unit"] === "Celcius"
            ? "ºC"
            : data["probe_temperature"]["unit"];
        const temperature = formatValue(
          data["probe_temperature"]["value"],
          temperature_unit
        );
        const snowDepth = formatValue(
          data["snow_depth"]["value"],
          data["snow_depth"]["unit"]
        );
        return {
          ...monitor,
          temperature,
          snowDepth,
        };
      });

      this.monitorData = await Promise.all(promises);
    } catch (error) {
      console.error("Error fetching monitor info:", error);
    }
  }

  getData() {
    return this.monitorData;
  }

  // This function is to fetch information from the local storage so that don't need to call API every time this refresh
  async fetchDataAndStore() {
    const localStorageKey = "monitorData";
    const storedData = localStorage.getItem(localStorageKey);

    if (storedData) {
      this.monitorData = JSON.parse(storedData);
    } else {
      await this.fetchDataFromAPI();
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

const ACCESS_KEY = typeof UNSPLASH_ACCESS_KEY === "string" ? UNSPLASH_ACCESS_KEY.trim() : "";

const state = {
  selectedPage: "home-page",
  savedOutfits: [],
  savedPlaces: [],
  luggageItems: [],
  selectedCity: null,
  weather: null,
};

const pageButtons = document.querySelectorAll(".nav-button");
const pages = document.querySelectorAll(".page");
const profileTabs = document.querySelectorAll(".profile-tab");
const profilePanels = document.querySelectorAll(".profile-panel");

const photoSearchInput = document.getElementById("photo-search");
const photoSearchButton = document.getElementById("photo-search-button");
const photoGrid = document.getElementById("photo-grid");
const photoError = document.getElementById("photo-error");

const citySearchInput = document.getElementById("city-search");
const citySearchButton = document.getElementById("city-search-button");
const cityError = document.getElementById("city-error");
const cityResults = document.getElementById("city-results");
const cityDetails = document.getElementById("city-details");

const savedPlacesContainer = document.getElementById("saved-places");
const savedOutfitsContainer = document.getElementById("saved-outfits");
const luggageItemsContainer = document.getElementById("luggage-items");
const addLuggageButton = document.getElementById("add-luggage-button");
const luggageNameInput = document.getElementById("luggage-name");
const luggageCategorySelect = document.getElementById("luggage-category");
const luggageModestInput = document.getElementById("luggage-modest");
const luggageWeatherInput = document.getElementById("luggage-weather");

function initialize() {
  pageButtons.forEach((button) => {
    button.addEventListener("click", () => switchPage(button.dataset.page));
  });

  profileTabs.forEach((tab) => {
    tab.addEventListener("click", () => switchProfileTab(tab.dataset.tab));
  });

  photoSearchButton.addEventListener("click", () => loadPhotos(photoSearchInput.value));
  photoSearchInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      loadPhotos(photoSearchInput.value);
    }
  });

  citySearchButton.addEventListener("click", () => searchCity(citySearchInput.value));
  citySearchInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      searchCity(citySearchInput.value);
    }
  });

  addLuggageButton.addEventListener("click", addLuggageItem);

  loadLocalData();
  renderProfile();
  loadDefaultPhotos();
}

function switchPage(pageId) {
  state.selectedPage = pageId;
  pageButtons.forEach((button) => {
    button.classList.toggle("active", button.dataset.page === pageId);
  });
  pages.forEach((page) => {
    page.classList.toggle("active", page.id === pageId);
  });

  if (pageId === "profile-page") {
    renderProfile();
  }
}

function switchProfileTab(tabId) {
  profileTabs.forEach((tab) => {
    tab.classList.toggle("active", tab.dataset.tab === tabId);
  });
  profilePanels.forEach((panel) => {
    panel.classList.toggle("active", panel.id === `${tabId}-tab`);
  });
}

function showError(element, message) {
  element.textContent = message;
  element.classList.remove("hidden");
}

function hideError(element) {
  element.textContent = "";
  element.classList.add("hidden");
}

const DEFAULT_PHOTO_QUERY = "fashion street style outfit clothing";
const UNSPLASH_FALLBACK_KEYWORDS = "fashion,street-style,outfit,clothing";

async function loadDefaultPhotos() {
  hideError(photoError);
  photoGrid.innerHTML = '<div class="card"><p>Loading photos...</p></div>';

  try {
    const photos = await getPhotos(DEFAULT_PHOTO_QUERY);
    renderPhotoGrid(photos);
  } catch (error) {
    console.error("Error loading photos:", error);
    showError(photoError, "Failed to load photos. Please check your connection.");
  }
}

async function loadPhotos(query) {
  const trimmed = query.trim();
  if (!trimmed) {
    loadDefaultPhotos();
    return;
  }

  hideError(photoError);
  photoGrid.innerHTML = "";
  const photos = await getPhotos(trimmed);
  if (photos.length === 0) {
    showError(photoError, "No style photos found.");
  }
  renderPhotoGrid(photos);
}

function buildFashionQuery(query) {
  const trimmed = query.trim();
  if (!trimmed) {
    return DEFAULT_PHOTO_QUERY;
  }
  return [trimmed, "fashion", "street style", "outfit", "clothing", "style"]
    .filter(Boolean)
    .join(" ");
}

async function getPhotos(query) {
  const builtQuery = buildFashionQuery(query);
  if (ACCESS_KEY) {
    try {
      const url = new URL("https://api.unsplash.com/search/photos");
      url.searchParams.set("query", builtQuery);
      url.searchParams.set("per_page", "24");
      url.searchParams.set("orientation", "portrait");

      const response = await fetch(url.toString(), {
        headers: {
          Authorization: `Client-ID ${ACCESS_KEY}`,
        },
      });

      if (!response.ok) {
        throw new Error(`Unsplash request failed (${response.status})`);
      }

      const data = await response.json();
      return data.results.map((item) => ({
        id: item.id,
        description: item.description || item.alt_description || "Street style",
        urls: {
          small: item.urls.small,
          regular: item.urls.regular,
        },
        user: { name: item.user.name || "Unsplash" },
      }));
    } catch (error) {
      console.warn(error);
      showError(photoError, "Could not load photos from Unsplash. Showing fashion-style sample images instead.");
      return getFallbackPhotos(query);
    }
  }

  return getFallbackPhotos(query);
}

function getFallbackPhotos(query) {
  const encodedQuery = encodeURIComponent(buildFashionQuery(query).replace(/\s+/g, ","));
  return Array.from({ length: 12 }, (_, index) => ({
    id: `fallback-${index}`,
    description: `${query} street style`,
    urls: {
      small: `https://source.unsplash.com/random/400x600?${encodedQuery}&sig=${index}`,
      regular: `https://source.unsplash.com/random/800x1200?${encodedQuery}&sig=${index}`,
    },
    user: { name: "Unsplash" },
  }));
}

function renderPhotoGrid(photos) {
  photoGrid.innerHTML = "";

  if (photos.length === 0) {
    photoGrid.innerHTML = `<div class="card"><p class="section-caption">No images are available right now.</p></div>`;
    return;
  }

  photos.forEach((photo) => {
    const card = document.createElement("article");
    card.className = "photo-card";
    card.style.breakInside = "avoid-column";
    card.style.WebkitColumnBreakInside = "avoid";
    card.innerHTML = `
      <img src="${photo.urls.small}" alt="${escapeHtml(photo.description)}" loading="lazy">
      <div class="photo-card-body">
        <div>
          <p>${escapeHtml(photo.user.name)}</p>
        </div>
        <button class="save-button ${isOutfitSaved(photo.urls.small) ? "active" : ""}" data-id="${photo.id}">
          ${isOutfitSaved(photo.urls.small) ? "Saved" : "Save"}
        </button>
      </div>
    `;

    const saveButton = card.querySelector(".save-button");
    saveButton.addEventListener("click", () => {
      toggleOutfit(photo);
      saveButton.classList.toggle("active", isOutfitSaved(photo.urls.small));
      saveButton.textContent = isOutfitSaved(photo.urls.small) ? "Saved" : "Save";
      renderProfile();
    });

    photoGrid.appendChild(card);
  });
}

function escapeHtml(text) {
  return String(text || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function loadLocalData() {
  state.savedOutfits = JSON.parse(localStorage.getItem("savedOutfits") || "[]");
  state.savedPlaces = JSON.parse(localStorage.getItem("savedPlaces") || "[]");
  state.luggageItems = JSON.parse(localStorage.getItem("luggageItems") || "[]");
}

function saveLocalData() {
  localStorage.setItem("savedOutfits", JSON.stringify(state.savedOutfits));
  localStorage.setItem("savedPlaces", JSON.stringify(state.savedPlaces));
  localStorage.setItem("luggageItems", JSON.stringify(state.luggageItems));
}

function isOutfitSaved(imageUrl) {
  return state.savedOutfits.some((item) => item.imageURL === imageUrl);
}

function toggleOutfit(photo) {
  const existingIndex = state.savedOutfits.findIndex((item) => item.imageURL === photo.urls.small);
  if (existingIndex >= 0) {
    state.savedOutfits.splice(existingIndex, 1);
  } else {
    state.savedOutfits.push({
      id: `outfit-${Date.now()}-${Math.random().toString(36).slice(2)}`,
      imageURL: photo.urls.regular,
      photographer: photo.user.name,
      savedDate: new Date().toISOString(),
      notes: "",
    });
  }
  saveLocalData();
}

async function searchCity(query) {
  const trimmed = query.trim();
  if (!trimmed) {
    showError(cityError, "Type a city name to search.");
    return;
  }

  hideError(cityError);
  cityResults.innerHTML = "";
  cityDetails.classList.add("hidden");

  try {
    const url = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(trimmed)}&count=10&language=en&format=json`;
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error("Could not fetch city information.");
    }

    const data = await response.json();
    if (!data.results || data.results.length === 0) {
      showError(cityError, "No cities found. Try a different search.");
      return;
    }

    cityResults.innerHTML = "";
    data.results.forEach((city) => {
      const card = document.createElement("div");
      card.className = "card";
      card.innerHTML = `
        <div class="place-title">${escapeHtml(city.name)}, ${escapeHtml(city.country)}</div>
        <div class="place-meta">${escapeHtml(city.admin1 || "")}</div>
        <div class="action-row">
          <button class="primary-button">View Info</button>
        </div>
      `;
      card.querySelector("button").addEventListener("click", () => selectCity(city));
      cityResults.appendChild(card);
    });
  } catch (error) {
    showError(cityError, error.message);
  }
}

async function selectCity(city) {
  state.selectedCity = city;
  cityResults.innerHTML = "";
  cityDetails.classList.remove("hidden");
  cityDetails.innerHTML = `<div class="card"><p class="section-caption">Loading weather and cultural guidance...</p></div>`;

  try {
    const weather = await fetchWeather(city.latitude, city.longitude);
    state.weather = weather;
    renderCityDetails(city, weather);
  } catch (error) {
    showError(cityError, "Could not load weather information.");
    cityDetails.classList.add("hidden");
  }
}

async function fetchWeather(lat, lon) {
  const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true&timezone=auto`;
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error("Unable to fetch weather data.");
  }
  const data = await response.json();
  return data.current_weather;
}

function renderCityDetails(city, weather) {
  const tempC = weather.temperature;
  const tempF = Math.round((tempC * 9) / 5 + 32);
  const strictness = getDressStrictness(city.country);
  const cultural = getCultureNotes(city.country);

  cityDetails.innerHTML = `
    <div class="detail-card">
      <h3>${escapeHtml(city.name)}, ${escapeHtml(city.country)}</h3>
      <div class="detail-grid">
        <div>
          <p class="section-caption">Temperature</p>
          <div class="detail-pill">${tempC.toFixed(1)}°C / ${tempF}°F</div>
        </div>
        <div>
          <p class="section-caption">Dress code level</p>
          <div class="detail-pill">${strictness}</div>
        </div>
      </div>
      <p class="section-caption">Cultural Dress Guidance</p>
      <p>${escapeHtml(cultural)}</p>
      <div class="action-row">
        <button id="save-destination-button" class="primary-button">Save Destination</button>
        <button id="new-destination-button" class="secondary-button">Search Another</button>
      </div>
    </div>
  `;

  document.getElementById("save-destination-button").addEventListener("click", saveSelectedDestination);
  document.getElementById("new-destination-button").addEventListener("click", () => {
    cityResults.innerHTML = "";
    cityDetails.classList.add("hidden");
    citySearchInput.value = "";
  });
}

function saveSelectedDestination() {
  if (!state.selectedCity || !state.weather) {
    return;
  }

  const entry = {
    id: `place-${Date.now()}-${Math.random().toString(36).slice(2)}`,
    cityName: state.selectedCity.name,
    country: state.selectedCity.country,
    latitude: state.selectedCity.latitude,
    longitude: state.selectedCity.longitude,
    temperature: `${state.weather.temperature.toFixed(1)}°C`,
    culturalNotes: getCultureNotes(state.selectedCity.country),
    strictnessLevel: getDressStrictness(state.selectedCity.country),
    savedDate: new Date().toISOString(),
  };

  const exists = state.savedPlaces.some((item) => item.cityName === entry.cityName && item.country === entry.country);
  if (!exists) {
    state.savedPlaces.push(entry);
    saveLocalData();
    renderProfile();
  }
}

function getDressStrictness(country) {
  const strictCountries = ["Saudi Arabia", "United Arab Emirates", "Japan", "South Korea", "India"];
  const moderateCountries = ["France", "United Kingdom", "Italy", "Spain", "Germany"];
  if (strictCountries.includes(country)) return "Strict";
  if (moderateCountries.includes(country)) return "Moderate";
  return "Casual";
}

function getCultureNotes(country) {
  const notes = {
    "Japan": "Respect local customs with polished layers, modest coverage, and neutral colors when you are visiting shrines or cities.",
    "France": "Chic, understated outfits work best; bring a light jacket and a smart pair of shoes for streets and cafes.",
    "Italy": "Fashionable layers and comfortable shoes are ideal for city walking in style-focused culture.",
    "United Arab Emirates": "Lightweight, modest attire is recommended; avoid sleeveless tops and short bottoms in public spaces.",
    "India": "Breathable fabrics and modest coverage keep you comfortable in warm weather and cultural settings.",
  };
  return notes[country] || "Choose breathable layers and comfortable footwear for local weather and cultural respect.";
}

function renderProfile() {
  renderSavedPlaces();
  renderSavedOutfits();
  renderLuggage();
}

function renderSavedPlaces() {
  savedPlacesContainer.innerHTML = "";
  if (state.savedPlaces.length === 0) {
    savedPlacesContainer.innerHTML = `<div class="card"><p class="section-caption">No saved destinations yet. Save a place from the Destinations tab.</p></div>`;
    return;
  }

  state.savedPlaces.forEach((place) => {
    const card = document.createElement("div");
    card.className = "card";
    card.innerHTML = `
      <div class="place-title">${escapeHtml(place.cityName)}, ${escapeHtml(place.country)}</div>
      <div class="place-meta">
        <span>${escapeHtml(place.temperature)}</span>
        <span>${escapeHtml(place.strictnessLevel)} dress code</span>
      </div>
      <p class="section-caption">${escapeHtml(place.culturalNotes)}</p>
      <div class="action-row">
        <button class="delete-button">Remove</button>
      </div>
    `;
    card.querySelector(".delete-button").addEventListener("click", () => {
      state.savedPlaces = state.savedPlaces.filter((item) => item.id !== place.id);
      saveLocalData();
      renderProfile();
    });
    savedPlacesContainer.appendChild(card);
  });
}

function renderSavedOutfits() {
  savedOutfitsContainer.innerHTML = "";
  if (state.savedOutfits.length === 0) {
    savedOutfitsContainer.innerHTML = `<div class="card"><p class="section-caption">No saved outfits yet. Save an outfit from the Style tab.</p></div>`;
    return;
  }

  state.savedOutfits.forEach((outfit) => {
    const card = document.createElement("article");
    card.className = "photo-card";
    card.innerHTML = `
      <img src="${outfit.imageURL}" alt="Saved outfit">
      <div class="photo-card-body">
        <div>
          <p>${escapeHtml(outfit.photographer)}</p>
        </div>
        <button class="delete-button">Remove</button>
      </div>
    `;
    card.querySelector(".delete-button").addEventListener("click", () => {
      state.savedOutfits = state.savedOutfits.filter((item) => item.id !== outfit.id);
      saveLocalData();
      renderProfile();
    });
    savedOutfitsContainer.appendChild(card);
  });
}

function addLuggageItem() {
  const name = luggageNameInput.value.trim();
  if (!name) {
    return;
  }

  const item = {
    id: `luggage-${Date.now()}-${Math.random().toString(36).slice(2)}`,
    name,
    category: luggageCategorySelect.value,
    isModest: luggageModestInput.checked,
    isWeatherAppropriate: luggageWeatherInput.checked,
  };

  state.luggageItems.push(item);
  saveLocalData();
  renderLuggage();
  luggageNameInput.value = "";
  luggageModestInput.checked = false;
  luggageWeatherInput.checked = false;
}

function renderLuggage() {
  luggageItemsContainer.innerHTML = "";
  if (state.luggageItems.length === 0) {
    luggageItemsContainer.innerHTML = `<div class="card"><p class="section-caption">Your luggage list is empty. Add gear for your next trip.</p></div>`;
    return;
  }

  state.luggageItems.forEach((item) => {
    const card = document.createElement("div");
    card.className = "luggage-item";
    card.innerHTML = `
      <div>
        <h4>${escapeHtml(item.name)}</h4>
        <div class="luggage-meta">
          <span>${escapeHtml(item.category)}</span>
          <span>${item.isModest ? "Modest" : "Not modest"}</span>
          <span>${item.isWeatherAppropriate ? "Weather appropriate" : "May need adjustment"}</span>
        </div>
      </div>
      <button class="delete-button">Remove</button>
    `;
    card.querySelector(".delete-button").addEventListener("click", () => {
      state.luggageItems = state.luggageItems.filter((entry) => entry.id !== item.id);
      saveLocalData();
      renderLuggage();
    });
    luggageItemsContainer.appendChild(card);
  });
}

initialize();

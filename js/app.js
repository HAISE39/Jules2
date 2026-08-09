// State variables
let currentGenre = "All";
let searchQuery = "";

// DOM Elements
const gamesGrid = document.getElementById("games-grid");
const searchInput = document.getElementById("search-input");
const gameCountText = document.getElementById("game-count");

// Modal Elements
const gameModal = document.getElementById("game-modal");
const modalBanner = document.getElementById("modal-banner");
const modalGenre = document.getElementById("modal-genre");
const modalTitle = document.getElementById("modal-title");
const modalRating = document.getElementById("modal-rating");
const modalPlayers = document.getElementById("modal-players");
const modalDescription = document.getElementById("modal-description");
const modalFeatures = document.getElementById("modal-features");
const btnPlayPopup = document.getElementById("btn-play-popup");
const btnPlayTab = document.getElementById("btn-play-tab");

// Initialize on page load
document.addEventListener("DOMContentLoaded", () => {
  if (window.lucide) {
    window.lucide.createIcons();
  }
  updateSidebarActiveState();
  renderGames();
});

// Real-time Search Input Handler
searchInput.addEventListener("input", (e) => {
  searchQuery = e.target.value.toLowerCase().trim();
  renderGames();
});

// Filter by genre
function filterGenre(genre) {
  currentGenre = genre;
  updateSidebarActiveState();
  renderGames();
}

// Reset filters back to default
function resetFilters() {
  searchInput.value = "";
  searchQuery = "";
  filterGenre("All");
}

// Update sidebar buttons visual active states
function updateSidebarActiveState() {
  const tabs = document.querySelectorAll(".genre-tab");
  tabs.forEach(tab => {
    if (tab.getAttribute("data-genre") === currentGenre) {
      tab.classList.add("sidebar-active");
      tab.classList.remove("text-slate-400");
    } else {
      tab.classList.remove("sidebar-active");
      tab.classList.add("text-slate-400");
    }
  });
}

// Render Games Grid (Compact cards matching CrazyGames style rules)
function renderGames() {
  gamesGrid.innerHTML = "";

  // Filter games based on genre and search query
  const filteredGames = gamesData.filter(game => {
    const matchesGenre = (currentGenre === "All" || game.genre === currentGenre);
    const matchesSearch = (game.title.toLowerCase().includes(searchQuery) || game.description.toLowerCase().includes(searchQuery));
    return matchesGenre && matchesSearch;
  });

  gameCountText.textContent = `${filteredGames.length} Game Tersedia`;

  if (filteredGames.length === 0) {
    gamesGrid.innerHTML = `
      <div class="col-span-full py-16 flex flex-col items-center justify-center text-center">
        <div class="w-12 h-12 rounded-full bg-slate-900/60 flex items-center justify-center border border-slate-800 text-slate-400 mb-4 animate-bounce">
          <i data-lucide="frown" class="w-6 h-6"></i>
        </div>
        <p class="text-sm font-bold text-slate-300">Tidak ada game ditemukan</p>
        <p class="text-[11px] text-slate-500 mt-1">Gunakan kata kunci pencarian atau kategori menu lainnya.</p>
      </div>
    `;
    if (window.lucide) window.lucide.createIcons();
    return;
  }

  // Generate compact game cards (CrazyGames aspect ratio 1:1 image boxes)
  filteredGames.forEach((game, index) => {
    const card = document.createElement("div");
    card.className = "crazy-card flex flex-col relative aspect-[4/3] sm:aspect-square overflow-hidden";
    card.setAttribute("onclick", `openGameDetails("${game.id}")`);

    // Dynamic Badge logic (e.g. Hot, New, Top) to enrich CrazyGames feel
    let badgeHtml = "";
    if (index % 3 === 0) {
      badgeHtml = `<span class="crazy-badge crazy-badge-hot">Hot</span>`;
    } else if (index % 5 === 1) {
      badgeHtml = `<span class="crazy-badge crazy-badge-new">New</span>`;
    } else if (index % 4 === 2) {
      badgeHtml = `<span class="crazy-badge crazy-badge-top">Top</span>`;
    }

    const defaultThumbnail = "https://g123.jp/news/calendar-date-range.svg";

    card.innerHTML = `
      <!-- Thumbnail with Overlay -->
      <div class="w-full h-full relative overflow-hidden bg-slate-900 flex items-center justify-center">
        ${badgeHtml}
        <img src="${game.image}" alt="${game.title}"
          class="w-full h-full object-cover transition-transform duration-300"
          onerror="this.onerror=null; this.src='${defaultThumbnail}'; this.style.objectFit='contain'; this.style.padding='16px';"
        >
        <!-- Overlay on Hover -->
        <div class="absolute inset-0 bg-black/80 flex flex-col justify-end p-3 opacity-0 hover:opacity-100 transition-opacity duration-200 z-20">
          <h4 class="text-xs font-black text-white line-clamp-1 mb-1">${game.title}</h4>
          <p class="text-[10px] text-slate-400 leading-normal line-clamp-2 mb-2">${game.description}</p>
          <div class="flex items-center justify-between text-[9px] font-bold text-slate-400 border-t border-slate-800 pt-1.5">
            <span class="text-yellow-400 flex items-center gap-0.5"><i data-lucide="star" class="w-2.5 h-2.5 fill-yellow-400"></i> ${game.rating}</span>
            <span class="text-indigo-400">${game.genre}</span>
          </div>
        </div>
      </div>
    `;

    gamesGrid.appendChild(card);
  });

  if (window.lucide) {
    window.lucide.createIcons();
  }
}

// Open Game Details in Modal
function openGameDetails(gameId) {
  const game = gamesData.find(g => g.id === gameId);
  if (!game) return;

  const defaultBanner = "https://platform-ik.g123.jp/g123/production-ctw-box/game-box/preview/dc54f171c99b83294c0849c40fa328b33e206b783e549f846d6dcfcc.jpg";

  // Set modal elements
  modalBanner.onerror = function() {
    this.onerror = null;
    this.src = defaultBanner;
  };
  modalBanner.src = game.banner;
  modalGenre.textContent = game.genre;
  modalTitle.textContent = game.title;
  modalRating.textContent = game.rating.toFixed(1);
  modalPlayers.textContent = game.players;
  modalDescription.textContent = game.description;

  // Build features list
  modalFeatures.innerHTML = "";
  game.features.forEach(feat => {
    const li = document.createElement("li");
    li.className = "flex items-start gap-2 text-xs text-slate-400";
    li.innerHTML = `
      <i data-lucide="check-circle" class="w-4 h-4 text-indigo-400 shrink-0 mt-0.5"></i>
      <span>${feat}</span>
    `;
    modalFeatures.appendChild(li);
  });

  if (window.lucide) {
    window.lucide.createIcons();
  }

  // Setup Launcher Actions
  btnPlayPopup.onclick = () => {
    const width = 1100;
    const height = 750;
    const left = (screen.width - width) / 2;
    const top = (screen.height - height) / 2;
    const options = `width=${width},height=${height},top=${top},left=${left},menubar=no,toolbar=no,location=no,status=no,resizable=yes,scrollbars=yes`;
    window.open(game.url, `G123_Standalone_${game.id}`, options);
    closeModal();
  };

  btnPlayTab.onclick = () => {
    window.open(game.url, "_blank");
    closeModal();
  };

  // Show Modal
  gameModal.classList.remove("hidden");
  setTimeout(() => {
    gameModal.classList.add("modal-transition-show");
  }, 10);
}

// Close Modal
function closeModal() {
  gameModal.classList.remove("modal-transition-show");
  setTimeout(() => {
    gameModal.classList.add("hidden");
  }, 200);
}

// Close Modal on clicking outside
gameModal.addEventListener("click", (e) => {
  if (e.target === gameModal) {
    closeModal();
  }
});

// State
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

// Initialize on load
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

// Render Games Grid
function renderGames() {
  // Clear Grid
  gamesGrid.innerHTML = "";

  // Filter games based on genre and search query
  const filteredGames = gamesData.filter(game => {
    const matchesGenre = (currentGenre === "All" || game.genre === currentGenre);
    const matchesSearch = (game.title.toLowerCase().includes(searchQuery) || game.description.toLowerCase().includes(searchQuery));
    return matchesGenre && matchesSearch;
  });

  // Update count text
  gameCountText.textContent = `Menampilkan ${filteredGames.length} Game`;

  if (filteredGames.length === 0) {
    gamesGrid.innerHTML = `
      <div class="col-span-full py-16 flex flex-col items-center justify-center text-center">
        <div class="w-14 h-14 rounded-full bg-slate-900/60 flex items-center justify-center border border-slate-800 text-slate-400 mb-4 animate-bounce">
          <i data-lucide="frown" class="w-6 h-6"></i>
        </div>
        <p class="text-base font-bold text-slate-300">Game tidak ditemukan</p>
        <p class="text-xs text-slate-500 mt-1">Gunakan kata kunci pencarian atau kategori menu lainnya.</p>
      </div>
    `;
    if (window.lucide) window.lucide.createIcons();
    return;
  }

  // Generate game cards
  filteredGames.forEach(game => {
    const card = document.createElement("div");
    card.className = "game-card rounded-2xl overflow-hidden cursor-pointer flex flex-col group h-full";
    card.setAttribute("onclick", `openGameDetails("${game.id}")`);

    // Safe error image handling to avoid fallback/fails
    const defaultThumbnail = "https://g123.jp/news/calendar-date-range.svg";

    card.innerHTML = `
      <!-- Thumbnail with Overlay -->
      <div class="relative h-44 w-full overflow-hidden bg-slate-900/50 flex items-center justify-center border-b border-slate-800/40">
        <img src="${game.image}" alt="${game.title}"
          class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-350"
          onerror="this.onerror=null; this.src='${defaultThumbnail}'; this.style.objectFit='contain'; this.style.padding='20px';"
        >
        <div class="absolute inset-0 bg-gradient-to-t from-[#0e1017] to-transparent opacity-40"></div>
        <div class="absolute top-3 right-3 z-10 bg-[#161824]/90 backdrop-blur px-2.5 py-1 rounded-lg text-xs font-bold text-yellow-400 flex items-center gap-1 border border-slate-800">
          <i data-lucide="star" class="w-3.5 h-3.5 fill-yellow-400"></i> ${game.rating}
        </div>
      </div>

      <!-- Content -->
      <div class="p-5 flex-grow flex flex-col justify-between">
        <div>
          <div class="text-[10px] font-bold text-indigo-400 tracking-wider uppercase mb-1.5">${game.genre}</div>
          <h3 class="text-base font-bold text-white mb-2 group-hover:text-indigo-400 transition-colors line-clamp-1">${game.title}</h3>
          <p class="text-slate-400 text-xs leading-relaxed line-clamp-2 mb-4">${game.description}</p>
        </div>

        <div class="flex items-center justify-between pt-4 border-t border-slate-800 mt-auto">
          <div class="text-[11px] font-mono text-slate-500">
            <span class="text-indigo-400 font-semibold">${game.players}</span> ONLINE
          </div>
          <span class="text-xs font-bold text-indigo-400 group-hover:text-indigo-300 flex items-center gap-1 transition-all">
            Play Game <i data-lucide="arrow-right" class="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform"></i>
          </span>
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
  }, 250);
}

// Close Modal on clicking outside
gameModal.addEventListener("click", (e) => {
  if (e.target === gameModal) {
    closeModal();
  }
});
